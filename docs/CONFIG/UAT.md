# UAT (978 MHz) Configuration Guide

This guide covers how to enable and configure UAT/978 MHz support in retar/tar1090. This is primarily used in the United States for general aviation aircraft.

---

## Enabling 978 MHz Support
If you have a primary 1090 MHz instance and want to include 978 MHz traffic from a secondary receiver:

1.  **Open the configuration file:**
    ```bash
    sudo nano /etc/default/tar1090
    ```
2.  **Toggle the UAT settings:**
    *   Change `ENABLE_978=no` to `ENABLE_978=yes`.
    *   If `dump978-fa` is running on a different computer, update the `URL_978` IP address:
        ```bash
        URL_978="http://127.0.0.1/skyaware978"
        ```
3.  **Save & Restart:**
    ```bash
    sudo systemctl restart tar1090
    ```

---

## Dedicated UAT-Only Instance
If you want to run an instance that *only* displays 978 MHz traffic (useful for dedicated UAT monitors):

1.  **Setup the instance path:**
    ```bash
    echo /run/skyaware978 tar1090 | sudo tee /etc/default/tar1090_instances
    ```
2.  **Deploy:** Run the install script again to apply the new path.
3.  **Note:** In this standalone mode, 978 MHz should be **disabled** (`ENABLE_978=no`) in the config file, as the instance is reading the data directly from the skyaware978 directory.

---

## Technical Note
UAT traffic will often be displayed similarly to ADS-B traffic in the interface; this is a known characteristic of how the data is handled by the underlying decoder scripts.
