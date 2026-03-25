# Sidebar banner (HTML injection)

The **sidebar banner** is optional HTML (and optional CSS) shown at the top of the sidebar table, above the search row.

## What it does

At startup, the UI may:

1. **Fetch** a small HTML document from a URL you configure (`SidebarBannerUrl`).
2. **Inject** its body content into **`#sidebar_banner_inject`** inside the row **`#aggregator_header`** (the id name is historical; the row is used for any enabled banner).
3. **Load** a stylesheet (`SidebarBannerCss`) into `<head>` when a banner URL is active, so you can style the injected markup without editing `style.css`.

If the fetch fails or the file is empty, the banner row stays hidden.

Relevant logic lives in **`html/script.js`** (search for `SidebarBannerUrl` / `sidebar_banner_inject`).

## Configuration (`defaults.js` / `config.js`)

| Variable | Default (in `defaults.js`) | Purpose |
|----------|----------------------------|---------|
| **`SidebarBannerUrl`** | `''` (empty) | URL path to the HTML fragment (e.g. `'banner.html'`). Empty means “no banner” unless **aggregator mode** supplies a default (see below). |
| **`SidebarBannerCss`** | `'banner.css'` | Stylesheet href loaded when a banner is shown. Set to `''` if you do not want an extra CSS file. |

Override these in **`html/config.js`** (see the commented block near the top of that file).

Example for a local site banner:

```javascript
SidebarBannerUrl = 'banner.html';
SidebarBannerCss = 'banner.css';
```

Paths are relative to the web root of the interface (same directory as `index.html`).

## Aggregator mode vs a plain site banner

**Aggregator mode** is controlled by **`aggregator`** in **`config.js`** / **`defaults.js`** (default `false`).

When **`aggregator`** is **`true`**:

- **Credits** blocks (`#credits`, `#creditsSelected`) are shown; text comes from **`CreditsText`** (default in `defaults.js` is `"retar"`).
- If **`SidebarBannerUrl`** is still empty, the code **defaults** the banner URL to **`'banner.html'`** so aggregator-style installs get a banner without setting `SidebarBannerUrl` explicitly.
- **`AggregatorBgEnabled`** (default `true`) toggles a decorative **background** on the selected infoblock (`.aggregator-selected-bg` in **`style.css`**), using **`images/favicon.png`** as a watermark-style graphic.
- Optional **`inhibitIframe`** (`defaults.js`): when `true`, the page may redirect the top window if loaded inside an iframe (intended for public aggregator deployments; adjust the target URL in **`script.js`** if you fork this behavior).

When **`aggregator`** is **`false`** (typical private receiver install):

- No credits unless you change other code.
- No banner unless you set **`SidebarBannerUrl`** yourself (e.g. to `'banner.html'`).

## Files: `banner.html` and `banner.css`

These files are **not** required to ship with the git tree. Many installs create them only on the server under the deployed **`html/`** directory.

Suggested layout:

- **`banner.html`** — Plain HTML fragment (no full `<html>` document required; whatever you inject should be valid inside a `<div>`). The script uses `fetch()` and inserts **`.trim()`** text as HTML.
- **`banner.css`** — Rules targeting classes/ids you use in `banner.html`. Loaded only when a banner URL is active.

Because **`install.sh`** copies a fresh tree from git into a temp directory on each run, it **preserves** an existing install’s customizations by moving the previous **`banner.html`** and **`banner.css`** from the live **`html_path`** into that temp tree before replacing **`html_path`**. So your banner files survive **install / update** as long as they live next to `index.html` on the target system.


## Quick checklist

1. Add **`banner.html`** (and optionally **`banner.css`**) next to **`index.html`** on the deployed host—or rely on install preserving existing copies.
2. In **`config.js`**, set **`SidebarBannerUrl`** / **`SidebarBannerCss`** (or enable **`aggregator`** if you want the aggregator defaults including implicit **`banner.html`**).
3. Run **install** as usual; **`banner.html`** / **`banner.css`** are carried forward from the previous **`html`** install directory.
