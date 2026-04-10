# UI Links Configuration

## Enable (/disable) FA links in the webinterface
(previously enabled by default)

```bash
# ENABLE:
sudo sed -i -e 's?.*flightawareLinks.*?flightawareLinks = true;?' /usr/local/share/tar1090/html/config.js
# ENABLE if the above doesn't work (updated from previous version)
echo 'flightawareLinks = true;' | sudo tee -a /usr/local/share/tar1090/html/config.js
# DISABLE:
sudo sed -i -e 's?.*flightawareLinks.*?flightawareLinks = false;?' /usr/local/share/tar1090/html/config.js
```

Then F5 to refresh the web interface in the browser.

If your instance is not at /tar1090 you'll need to edit the config.js in the approppriate html folder, see "Multiple instances" in the main README.

## Enable Share links to ADSB Aggregator sites or other websites using tar1090

```bash
# ENABLE:
sudo sed -i -e 's?.*shareBaseUrl.*?shareBaseUrl  = "https://globe.adsbsite.com/";?' /usr/local/share/tar1090/html/config.js
# ENABLE if the above doesn't work (updated from previous version)
echo 'shareBaseUrl  = "https://globe.adsbsite.com/";' | sudo tee -a /usr/local/share/tar1090/html/config.js
# DISABLE:
sudo sed -i -e 's?.*shareBaseUrl.*?shareBaseUrl = false;?' /usr/local/share/tar1090/html/config.js
```

If your instance is not at /tar1090 you'll need to edit the config.js in the approppriate html folder, see "Multiple instances" in the main README.
