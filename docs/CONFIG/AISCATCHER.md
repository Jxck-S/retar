# AIS-catcher Integration

## What is AIS-catcher?
[AIS (Automatic Identification System)](https://en.wikipedia.org/wiki/Automatic_identification_system) is an automated tracking system used on ships and marine vessels. It broadcasts a ship's identity, position, course, and speed to other nearby ships and coastal authorities.

`AIS-catcher` is a software receiver that decodes these AIS signals (usually using inexpensive RTL-SDR dongles) and can serve the decoded vessel data locally over a web interface.

## How it integrates with retar/tar1090
While `retar` (and `tar1090`) is primarily built to visualize aircraft (ADS-B) data, it can also pull in marine vessel data from an `AIS-catcher` instance. It achieves this by having your web browser periodically fetch a GeoJSON tracking feed from the `AIS-catcher` server. The web interface then renders the vessels as additional markers onto the exact same map, allowing you to track planes and ships simultaneously.

## Configuration

To enable this integration, refer to the "Configuring part 2: the web interface" section in the main `README.md` file to edit your `config.js`.

This is the relevant part in the configuration file:
```javascript
// aiscatcher_server = "http://192.168.1.113:8100"; // update with your server address
// aiscatcher_refresh = 15; // refresh interval in seconds
```
You can remove the `//` to uncomment the lines.

### Important Notes
- **Network Reachability:** Make sure that the server address is reachable from the device you are viewing the tar1090 page from (i.e. `localhost` / `127.0.0.1` will not work here unless you are viewing the tar1090 interface from the *same machine* you are running AIS-catcher on — in all other cases it will need to be the local IP of the server). 
- **Auto-populating IP:** If you run AIS-catcher and tar1090 on the same machine, you can use the host-relative magic token `HOSTNAME` to auto-populate the IP of the system - for example `http://HOSTNAME:8100`.
- **Enabling GeoJSON:** For this to work, you must have started AIS-catcher with the geojson flag set to on using the option `-N 8100 geojson on`. You should be able to verify it works by visiting the `aiscatcher_server` address with `/geojson` appended to it (e.g. `http://192.168.1.113:8100/geojson`).
