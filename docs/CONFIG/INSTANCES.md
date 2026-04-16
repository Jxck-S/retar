# Multiple Instances Guide

This guide covers how to install and manage multiple concurrent instances of the map on a single server (e.g., one for ADS-B, one for UAT, and one for a combined feed).

---

## 1. Setting up Instances
The automated script can manage multiple instances by reading from the `/etc/default/tar1090_instances` file.

1.  **Edit the instance list:**
    ```bash
    sudo nano /etc/default/tar1090_instances
    ```
2.  **Format:** Each line must contain one instance with the **source directory** and the **URL path**.
    *   *Example file:*
        ```text
        /run/dump1090-fa tar1090
        /run/combine1090 combo
        /run/skyaware978 978
        /run/dump1090-fa webroot
        ```
    *   *Note:* If you want the instance at `http://pi/`, use `webroot` as the name.
3.  **Deploy:** After saving the file, run the main install script:
    ```bash
    sudo bash -c "$(wget -nv -O - https://github.com/Jxck-S/retar/raw/main/install.sh)"
    ```

---

## 2. Managing Instance Configurations
Each instance has its own separate configuration files based on its name.

### Service Settings (/etc/default/):
*   `tar1090`: `/etc/default/tar1090`
*   `combo`: `/etc/default/tar1090-combo`
*   `978`: `/etc/default/tar1090-978`

### Web UI Settings (config.js):
*   `tar1090`: `/usr/local/share/tar1090/html/config.js`
*   `combo`: `/usr/local/share/tar1090/html-combo/config.js`
*   `978`: `/usr/local/share/tar1090/html-978/config.js`

### Service Names:
Systemd services and run directories follow the same pattern (`tar1090-[name]`). The main instance is the only exception, being called simply `tar1090`.

---

## 3. Removing an Instance
To remove a specific instance (e.g., "combo"):

1.  **Remove the line** from `/etc/default/tar1090_instances` so it isn't re-created during updates.
2.  **Run the uninstaller** for that specific name:
    ```bash
    sudo bash /usr/local/share/tar1090/uninstall.sh tar1090-combo
    ```
    *Note: If the instance was installed with a very old version, you might need to omit the `tar1090-` prefix:*
    ```bash
    sudo bash /usr/local/share/tar1090/uninstall.sh combo
    ```
