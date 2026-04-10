# Configuration Guide

This document provides a central hub for all configuration options available in retar/tar1090.

---

## Web Interface Configuration (config.js)
The most common way to customize the map (changing link behavior, enabling/disabling UI features) is via the `config.js` file.

### How to edit:
1.  **Open the file:**
    ```bash
    sudo nano /usr/local/share/tar1090/html/config.js
    ```
2.  **Enable settings:** Remove the `//` from the start of any line to activate that feature.
3.  **Save & Exit:** Press `Ctrl-X`, then `Y`, then `Enter`.
4.  **Refresh:** Press `Ctrl-F5` (or `Cmd-Shift-R` on Mac) in your browser to see the changes.

---

## Web Server & Caching
Detailed instructions for setting up and optimizing your web server.
- **[Web Server Configuration](docs/CONFIG/WEBSERVER.md)** (Nginx, Lighttpd)
- **[Caching & Proxy Configuration](docs/CONFIG/CACHING.md)** (Cloudflare)

## User Interface Configuration
Settings to customize the look and feel of the web interface.
- **[UI Links & Features](docs/CONFIG/UI-CONFIG.md)** (FlightAware links, share buttons)
- **[Coverage Range Outlines](docs/CONFIG/RANGE-OUTLINE.md)** (heywhatsthat.com integration)
- **[Offline Map Setup](docs/CONFIG/OFFLINEMAP.md)** (Self-hosted map tiles)

## System Configuration
Settings for the decoder, history, and advanced deployments.
- **[Aircraft History & Persistence](docs/CONFIG/HISTORY.md)** (pTracks, Heatmaps, long-term storage)
- **[Multiple Instances](docs/CONFIG/INSTANCES.md)** (Running concurrent maps/feeds)
- **[UAT (978 MHz) Setup](docs/CONFIG/UAT.md)** (Secondary receiver configuration)
- **[AIS Marine Tracking](docs/CONFIG/AISCATCHER.md)** (Vessel visualization)

### Home / receiver location
This is set in the decoder (e.g., `readsb`). If you used one of the standard install scripts, refer to the decoder's documentation for instructions on how to set the antenna location.

### Advanced Setup
- Refer to the main [README.md](README.md) for core settings like history interval and multiple instance setup.
- Technical details can be found in **[Technical Architecture](docs/TECHNICAL.md)**.

---

### Troubleshooting & Repairs
If you somehow broke the interface or want to revert to the default configuration:
1. Delete the active configuration:
   ```bash
   sudo rm /usr/local/share/tar1090/html/config.js
   ```
2. Run the install script again to restore defaults.
