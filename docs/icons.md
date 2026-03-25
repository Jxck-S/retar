# Web icons (favicon and PWA)

The install process builds raster icons from a **single SVG** so the tab icon, iOS home screen, and Android-style manifest icons stay consistent.

## Default vs custom artwork

| Source | When it is used |
|--------|-----------------|
| **Custom** | If the file **`customIcon.svg`** exists in the **install path** (`$ipath`, default `/usr/local/share/tar1090/`), that SVG is used as the master artwork. |
| **Default** | Otherwise the bundled **`html/images/favicon.svg`** from the repo is used (copied into the staged tree first, then processed). |

On every install or update, **`install.sh`** runs **`generate_web_icons.sh`** against the staged HTML directory. If you add or change **`customIcon.svg`** under `$ipath`, the next install regenerates all derived icons from it.

You do **not** need to edit files under `html/images/` by hand for a custom look; place **`customIcon.svg`** at `$ipath` and reinstall or run the same install flow.

## Generated files

The script **`generate_web_icons.sh`** (repository root) writes into the staged **`images/`** folder (next to `index.html`):

| File | Role |
|------|------|
| **`images/icon.svg`** | Copy of the chosen source SVG (scalable icon for modern browsers). |
| **`images/favicon.png`** | 32×32 PNG (legacy tab icon fallback; also referenced from **`style.css`**). |
| **`images/apple-touch-icon.png`** | 180×180 PNG; artwork is rendered on a **white** background for iOS. |
| **`images/icon-192.png`** | PWA / manifest (192×192). |
| **`images/icon-512.png`** | PWA / manifest (512×512). |

There is **no** `favicon.ico`; tab icons rely on SVG + PNG links in **`index.html`**.

## Web App Manifest name (not the icon image)

**`manifest.webmanifest`** ships with default `name` / `short_name` in the repo. During install, **`install.sh`** can rewrite those (and optional **`description`**) from **`/etc/default/<service>`** when you set:

- **`PAGENAME`** — sets manifest **`name`** and **`short_name`** (same as the HTML `<title>` and **`PageName`** in `config.js` when the installer applies them).
- **`DESCRIPTION`** — sets manifest **`description`** (same idea as the meta description / **`PageDescription`**).

So the **label** shown when “adding to home screen” comes from service defaults, not from the SVG file.

## Dependencies (regenerating from SVG)

To actually rasterize the SVG on the machine running install, you need **at least one** of:

- **`rsvg-convert`** — package is often named **`librsvg2-bin`** (Debian/Ubuntu) or **`librsvg2-tools`** (Fedora); on macOS, **`librsvg`** via Homebrew.
- **ImageMagick** — **`imagemagick`** (provides `magick` or `convert`) as a fallback if `rsvg-convert` is not available.

If neither is installed, the script logs a message and leaves the **prebuilt** PNG/SVG files that came from **`cp -r html`** (the committed assets in the repo).

**`jq`** is required by **`install.sh`** for updating **`manifest.webmanifest`**; it is not used by **`generate_web_icons.sh`**.

## Quick reference

- **Custom icon:** `$ipath/customIcon.svg` (e.g. `/usr/local/share/tar1090/customIcon.svg`).
- **Default icon:** `html/images/favicon.svg` in the git checkout.
- **Script:** `generate_web_icons.sh` — invoked automatically from **`install.sh`**; arguments are the staged HTML tree and **`$ipath`**.
