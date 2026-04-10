# heywhatsthat.com range outline

To judge the actual range (/?pTracks), one needs to first know what kind of range is even possible for the receiver location. 1090 MHz reception requires a direct line of sight through air to what you want to receive, thus depends on obstacles and the curvature of the earth. To get that theoretical range for a location, follow the guide in this chapter.

#### 1: Create panorama and look at your outline on the heywhatsthat page
- Visit <http://www.heywhatsthat.com/>
- Click "New Panorama"
- Set the location for your antenna precisely
- Enter a title / submit the request and wait for it to finish
- Scroll down to the map, look at the buttons in the top right of the map
- Use the "up in the air" button on the map, reduce map magnification
- You can change the altitudes (ft) below the map to view different outlines for your location
- Those outlines tell you how far you can receive aircraft at the associated altitudes
- The panorama does not take into account obstacles closer to the antenna than approximately 100 ft, trees are also not considered but can block reception

#### 2: Integrate theoretical range outline into your local tar1090 display
- For use on the tar1090 map the altitude will be set by changing the download URL
- Near the top of the page, an URL for the panorama is mentioned.
- Replace the XXXXXX in the following command with the ID contained in your panorama URL, then run the command on your pi:

```bash
sudo /usr/local/share/tar1090/getupintheair.sh XXXXX
```

- You should now have a range outline for the theoretical range for aircraft at 40000 ft on your tar1090 map
- It might be interesting to compare to `http://[IP_ADDRESS]/tar1090/?pTracks` which will by default will display the last 8 hours of traces.

#### More options for loading multiple outlines and for a different instance
```bash
# load two outlines, 10000 ft and 40000 ft
sudo /usr/local/share/tar1090/getupintheair.sh XXXXX 3048,12192

# load a 10000 ft outline for the tar1090 instance located at /978
sudo /usr/local/share/tar1090/getupintheair.sh XXXXX 3048 978

# load a 40000 ft outline for the tar1090 instance located at /adsbx
sudo /usr/local/share/tar1090/getupintheair.sh XXXXX 12192 adsbx
```
