# Web icons (favicon and PWA)

The install process builds raster icons from a **single SVG** so the tab icon, iOS home screen, and Android-style manifest icons stay consistent.

## Default vs custom artwork

| Source | When it is used |
|--------|-----------------|
| **Custom** | If the file **`customIcon.svg`** exists in the **install path** (`$ipath`, default `/usr/local/share/tar1090/`), that SVG is used as the master artwork. |
| **Default** | Otherwise the bundled **`html/images/icon.svg`** from the repo is used as the only SVG master file (no separate `favicon.svg`). |

On every install or update, **`install.sh`** runs **`generate_web_icons.sh`** against the staged HTML directory. If you add or change **`customIcon.svg`** under `$ipath`, the next install regenerates all derived icons from it.

You do **not** need to edit files under `html/images/` by hand for a custom look; place **`customIcon.svg`** at `$ipath` and reinstall or run the same install flow.

## Generated files

The script **`generate_web_icons.sh`** (repository root) writes into the staged **`images/`** folder (next to `index.html`):

| File | Role |
|------|------|
| **`images/icon.svg`** | Bundled default SVG, or replaced by **`customIcon.svg`** on install; linked from **`index.html`** as the scalable tab icon. |
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

## Dependencies for `generate_web_icons.sh`

The script needs **at least one** way to turn SVG into PNG. It looks for binaries in this order:

1. **`rsvg-convert`** (or **`rsvg-convert-qt`**) — **recommended**
2. **`magick`** or **`convert`** (ImageMagick) — fallback; SVG is often restricted on Debian/Ubuntu unless you relax **`policy.xml`**, so prefer rsvg.

### Install packages (pick your OS)

| OS / family | Package | Command |
|-------------|---------|---------|
| **Debian / Ubuntu / Raspberry Pi OS** | `librsvg2-bin` | `sudo apt install librsvg2-bin` |
| **Fedora** | `librsvg2-tools` | `sudo dnf install librsvg2-tools` |
| **Arch Linux** | `librsvg` | `sudo pacman -S librsvg` |
| **macOS** (Homebrew) | `librsvg` | `brew install librsvg` |

**ImageMagick fallback** (only if you cannot use `rsvg-convert`):

| OS | Command |
|----|---------|
| Debian / Ubuntu | `sudo apt install imagemagick` |
| Fedora | `sudo dnf install ImageMagick` |
| Arch | `sudo pacman -S imagemagick` |
| macOS | `brew install imagemagick` |

After install, confirm: `command -v rsvg-convert` or `command -v magick`.

### If you install nothing extra

- **`install.sh`** still succeeds (`generate_web_icons.sh` is run with `|| true`).
- The deployed site uses the **committed** `images/*.png` and **`icon.svg`** copied from git; they are **not** rebuilt from **`customIcon.svg`** until a raster tool is available.

### Partial failure

- If **32×32** rasterization fails, PNG generation for that run stops early.
- **192 / 512 / Apple** are best-effort (`|| true`); a failure there can leave an older file from a previous install.

## Other install-time dependency (manifest only, not the icon script)

**`jq`** is required by **`install.sh`** to patch **`manifest.webmanifest`** when **`PAGENAME`** / **`DESCRIPTION`** are set. The normal tar1090 install path already expects **`jq`** (see **`install.sh`** / `command_package`). It is **not** used by **`generate_web_icons.sh`**.

## Quick reference

- **Custom icon:** `$ipath/customIcon.svg` (e.g. `/usr/local/share/tar1090/customIcon.svg`).
- **Default icon:** `html/images/icon.svg` in the git checkout.
- **Script:** `generate_web_icons.sh` — invoked automatically from **`install.sh`**; arguments are the staged HTML tree and **`$ipath`**.
- **Packages for the script:** see **Dependencies for `generate_web_icons.sh`** above (`librsvg2-bin` on Debian/Ubuntu is the usual choice).
