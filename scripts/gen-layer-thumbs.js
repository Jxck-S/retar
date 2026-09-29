#!/usr/bin/env node
// Renders a small preview of every base map for the Layers tab of the map panel.
// Output: html/images/layers/<layer name>.webp (the name is the layer's `name` in layers.js).
//
// Usage: start the dev server (npm start), then
//   node scripts/gen-layer-thumbs.js                 all base maps
//   node scripts/gen-layer-thumbs.js osm esri_sat    only these layers
//   node scripts/gen-layer-thumbs.js --missing       only layers without a thumbnail yet
//   URL=http://localhost:8080 node scripts/gen-layer-thumbs.js
//
// Layers that fail to render are reported and skipped; the panel shows a
// coloured tile with the map's initials for any layer without a thumbnail.

const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const BASE_URL = process.env.URL || 'http://localhost:8080';
const OUT_DIR = path.join(__dirname, '..', 'html', 'images', 'layers');

// Where each region's maps are pictured: [lon, lat, zoom].
// San Francisco Bay shows water, land, roads and (on the US charts) Class B airspace.
const VIEWS = {
    world: [-122.3, 37.72, 9],
    us: [-122.3, 37.72, 9],
    europe: [8.57, 50.04, 9], // Frankfurt
    custom: [-122.3, 37.72, 9],
};

const CLIP = { width: 540, height: 360 }; // captured from the middle of the map
const OUT = { width: 360, height: 240 };  // 2x the tile size in the panel
const QUALITY = 0.78;
const RENDER_TIMEOUT = 25000;
const BLANK_BYTES = 1500; // a single-colour 360x240 WebP is well under this

async function main() {
    const args = process.argv.slice(2);
    const missingOnly = args.includes('--missing');
    const only = args.filter(a => !a.startsWith('--'));

    fs.mkdirSync(OUT_DIR, { recursive: true });

    const browser = await chromium.launch();
    const page = await browser.newPage({ viewport: { width: 1200, height: 800 }, deviceScaleFactor: 1 });

    console.log(`Loading ${BASE_URL} …`);
    await page.goto(BASE_URL + '/?hideSidebar&hideButtons', { waitUntil: 'domcontentloaded' });
    await page.waitForFunction(() => typeof loadFinished !== 'undefined' && loadFinished && OLMap && layers_group, null, { timeout: 60000 });

    // Map only: no aircraft, overlays, controls, dimming or other UI on top
    const layers = await page.evaluate(() => {
        if (toggles['MapDim'])
            toggles['MapDim'].toggle(false);
        // the region groups (world / us / europe …) sit directly on the map; hide everything else
        const mapGroups = new Set(layers_group.getLayers().getArray());
        OLMap.getLayers().forEach(l => { if (!mapGroups.has(l)) l.setVisible(false); });
        const style = document.createElement('style');
        style.textContent = `
            #map_canvas { position: fixed !important; inset: 0 !important; width: 100vw !important; height: 100vh !important; z-index: 2147483647; }
            .ol-overlaycontainer, .ol-overlaycontainer-stopevent { display: none !important; }`;
        document.head.appendChild(style);
        OLMap.updateSize();

        const out = [];
        layers_group.getLayers().forEach(group => {
            if (!(group instanceof ol.layer.Group))
                return;
            ol.control.LayerSwitcher.forEachRecursive(group, lyr => {
                if (lyr.get('type') === 'base' && lyr.get('title') && lyr.get('name'))
                    out.push({ name: lyr.get('name'), title: lyr.get('title'), region: group.get('name') || 'world' });
                else if (lyr.get('type') === 'overlay')
                    lyr.setVisible(false);
            });
        });
        return out;
    });

    const todo = layers.filter(l => {
        if (only.length && !only.includes(l.name))
            return false;
        if (missingOnly && fs.existsSync(path.join(OUT_DIR, l.name + '.webp')))
            return false;
        return true;
    });
    if (only.length) {
        const unknown = only.filter(n => !layers.some(l => l.name === n));
        if (unknown.length)
            console.warn('Not a base map on this server: ' + unknown.join(', '));
    }
    console.log(`Rendering ${todo.length} of ${layers.length} base maps`);

    const failed = [];
    for (const layer of todo) {
        const [lon, lat, zoom] = VIEWS[layer.region] || VIEWS.world;
        process.stdout.write(`  ${layer.name.padEnd(28)} ${layer.title} … `);
        try {
            let buf = null;
            // vector styles can finish loading after the first rendercomplete, which
            // leaves a flat background; retry once with a longer settle if so
            for (let attempt = 0; attempt < 2 && (!buf || buf.length < BLANK_BYTES); attempt++)
                buf = await capture(page, layer, lon, lat, zoom, attempt ? 3000 : 400);
            if (buf.length < BLANK_BYTES)
                throw new Error('rendered blank');
            fs.writeFileSync(path.join(OUT_DIR, layer.name + '.webp'), buf);
            console.log(`${(buf.length / 1024).toFixed(1)} KB`);
        } catch (e) {
            console.log('FAILED: ' + e.message);
            failed.push(layer.name);
        }
    }

    await browser.close();
    if (failed.length) {
        console.log(`\n${failed.length} failed (they get the initials tile): ${failed.join(', ')}`);
        process.exitCode = 1;
    }
}

async function capture(page, layer, lon, lat, zoom, settle) {
    const rendered = await page.evaluate(({ name, lon, lat, zoom, timeout }) => new Promise(resolve => {
        ol.control.LayerSwitcher.forEachRecursive(layers_group, lyr => {
            if (lyr.get('type') === 'base')
                lyr.setVisible(lyr.get('name') === name);
        });
        const view = OLMap.getView();
        view.setCenter(ol.proj.fromLonLat([lon, lat]));
        view.setZoom(zoom);
        const timer = setTimeout(() => resolve(false), timeout);
        OLMap.once('rendercomplete', () => { clearTimeout(timer); resolve(true); });
        OLMap.render();
    }), { name: layer.name, lon, lat, zoom, timeout: RENDER_TIMEOUT });
    if (!rendered)
        throw new Error('tiles did not finish loading');
    await page.waitForTimeout(settle); // let vector styles and fades settle

    const vp = page.viewportSize();
    const png = await page.screenshot({
        clip: { x: (vp.width - CLIP.width) / 2, y: (vp.height - CLIP.height) / 2, width: CLIP.width, height: CLIP.height },
    });
    // Chrome encodes WebP, so no image library is needed
    const webp = await page.evaluate(async ({ b64, w, h, q }) => {
        const img = new Image();
        img.src = 'data:image/png;base64,' + b64;
        await img.decode();
        const canvas = document.createElement('canvas');
        canvas.width = w;
        canvas.height = h;
        const ctx = canvas.getContext('2d');
        ctx.imageSmoothingQuality = 'high';
        ctx.drawImage(img, 0, 0, w, h);
        return canvas.toDataURL('image/webp', q).split(',')[1];
    }, { b64: png.toString('base64'), w: OUT.width, h: OUT.height, q: QUALITY });
    return Buffer.from(webp, 'base64');
}

main().catch(e => {
    console.error(e);
    process.exit(1);
});
