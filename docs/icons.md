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

**Raster tools (pick one chain — the script tries in this order):**

1. **`rsvg-convert`** (preferred) — Debian/Ubuntu: **`librsvg2-bin`** · Fedora: **`librsvg2-tools`** · macOS: **`librsvg`** (Homebrew). Also accepts **`rsvg-convert-qt`** if present.
2. **ImageMagick** — package **`imagemagick`** (`magick` or `convert`) if `rsvg-convert` is not installed.

**Fallback when no raster tool exists**

- The script prints a short message and **exits without failing install** (`install.sh` uses `|| true`).
- The live site keeps the **prebuilt** `images/*.png` and **`icon.svg`** that were copied from git with **`cp -r html`** before the generator ran. So **no extra packages are required** for a working UI; you only need a tool above if you want **install-time** regeneration from SVG (including **`customIcon.svg`**).

**Partial failure**

- If **32×32** rasterization fails, nothing is overwritten for that step and the script stops early for PNG generation.
- **192 / 512 / Apple** use best-effort (`|| true`); a rare failure there could leave an old file from a previous install.

**Other**

- **`jq`** is used by **`install.sh`** for **`manifest.webmanifest`** only, not by **`generate_web_icons.sh`**.

## Quick reference

- **Custom icon:** `$ipath/customIcon.svg` (e.g. `/usr/local/share/tar1090/customIcon.svg`).
- **Default icon:** `html/images/favicon.svg` in the git checkout.
- **Script:** `generate_web_icons.sh` — invoked automatically from **`install.sh`**; arguments are the staged HTML tree and **`$ipath`**.
