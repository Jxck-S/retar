# retar

An extremely fast, high-performance UI for ADS-B data visualization, designed for use with **dump1090** and **readsb**.

This is a **detached fork of wiedehopf's tar1090**. While the original tar1090 provides a powerful engine, its interface is a legacy UI that often feels like it was designed in the early 2000s.

This fork cleans up the user experience under the name **retar**. It provides a cleaner look and feel.

![retar web interface example](docs/example.png)

## [Live Demo](https://jxck-s.github.io/retar/demo/)

No hardware required. The demo loads static sample data so you can explore the map, filters, and interface in your browser.

## [Documentation](https://jxck-s.github.io/retar/documentation/)

*   **[Configuration Guide](https://jxck-s.github.io/retar/documentation/#/docs/CONFIG)**: Configuring retar.
*   **[User Guide](https://jxck-s.github.io/retar/documentation/#/docs/USER_GUIDE)**: How to use the map, filters, and UI features.

---

## Installation

```
sudo bash -c "$(wget -nv -O - https://github.com/Jxck-S/retar/raw/master/install.sh)"
```

## View the added webinterface

Click the following URL and replace the IP address of your instance:

http://[IP_ADDRESS]/tar1090

If you are curious about your coverage, try this URL:

http://[IP_ADDRESS]/?pTracks

## Update (same command as installation)

```
sudo bash -c "$(wget -nv -O - https://github.com/Jxck-S/retar/raw/master/install.sh)"
```

Configuration should be preserved.

## Remove / Uninstall

```
sudo bash -c "$(wget -nv -O - https://github.com/Jxck-S/retar/raw/master/uninstall.sh)"
```
