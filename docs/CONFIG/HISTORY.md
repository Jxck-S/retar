# Aircraft History & Persistence Guide

This guide covers how to manage aircraft history, long-term data retention, and visualization tools like pTracks and Heatmaps.

---

## 1. Short-term History (Interface Settings)
You can change how often data is saved and how many snapshots are kept in the web interface.

Edit the service configuration:
```bash
sudo nano /etc/default/tar1090
```

*   **INTERVAL:** Seconds between snapshots.
*   **HISTORY_SIZE:** Number of snapshot files to save.
*   **Total Duration:** `INTERVAL` × `HISTORY_SIZE` = Seconds of history shown in the browser.

Apply changes:
```bash
sudo systemctl restart tar1090
```

---

## 2. Coverage Visualization (pTracks)
The `?pTracks` URL shows a visual representation of your antenna's coverage based on recently seen aircraft traces.

*   **View Coverage:** `http://[IP_ADDRESS]/tar1090/?pTracks`
*   **Duration:** Defaults to 8 hours. You can change this in the config file.
*   **Limit shown time:** Use `/tar1090/?pTracks=2` for just the last 2 hours.
*   **Performance Tuning:** Draw fewer points for faster loading: `/tar1090/?pTracks=8&pTracksInterval=60`

---

## 3. Long-term Persistence
This feature allows for indefinite data storage, used primarily by large aggregators for historical analysis. **Warning:** This will use significant disk space and increase disk write cycles.

### Prerequisites
Requires the **readsb** decoder (wiedehopf fork).

### Setup
1.  **Create directory:**
    ```bash
    sudo mkdir /var/globe_history
    sudo chown readsb /var/globe_history
    ```
2.  **Configure readsb:** Add these options to `/etc/default/readsb`:
    ```bash
    --write-globe-history /var/globe_history --heatmap 30
    ```
3.  **Database files:** For enhanced aircraft info, download the database:
    ```bash
    wget -O /usr/local/share/tar1090/aircraft.csv.gz https://github.com/wiedehopf/tar1090-db/raw/csv/aircraft.csv.gz
    ```
    And add `--db-file /usr/local/share/tar1090/aircraft.csv.gz` to your readsb config.

---

## 4. Heatmaps
Visualize high-density traffic areas using data from the persistence feature.

*   **Access Heatmap:** `http://[IP_ADDRESS]/tar1090/?heatmap=200000`

### URL Parameters:
*   `&heatDuration=48`: Show last 48 hours.
*   `&heatEnd=48`: Show 48 hours of data ending 48 hours ago.
*   `&heatRadius=2`: Change dot size.
*   `&heatAlpha=2`: Change opacity.
*   `&realHeat`: Enable an alternative blurry display style.

---

## 5. Separate History Instance
If you want to keep a standard 2-hour map but have a separate 24-hour "Persist" map:

1.  Edit `/etc/default/tar1090_instances`:
    ```text
    /run/readsb tar1090
    /run/readsb persist
    ```
2.  Run the install script again.
3.  Configure the new instance in `/etc/default/tar1090-persist`:
    ```bash
    INTERVAL=20
    HISTORY_SIZE=4300
    ```
4.  Restart the service: `sudo systemctl restart tar1090-persist`
5.  View at: `http://[IP_ADDRESS]/persist/?pTracks`
