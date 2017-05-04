## Setup

After burning your SD Card follow the instructions below to connect Rosetta Home to WiFi. Alternatively you can just plug it in to ethernet.


1. Plug in all USB dongles
  * MeteoStick
  * Raven SMCD
  * Touchstone Gateway
2. Ensure microSD card is fully inserted into Raspberry Pi
3. Power on Raspberry Pi with a 5.1v 2.5amp power supply
4. Put your phone in airplane mode
5. Turn **ONLY** WiFi back on, usually by tapping your WiFi button after enabling Airplane mode.
6. Connect to **ROSETTA_HOME** network/SSID
7. Go to http://192.168.24.1:8080/network
  * Currently Firefox is not supported.
8. Select network and enter network passcode into text input
9. Hit **Connect**
10. Reconnect to the same network you connected the PI too
11. Wait up to 1 minute, usually a 10-20 seconds
12. Goto http://rosetta.local:8080 in your browser
13. If http://rosetta.local:8080 isn’t available after a few minutes there’s a chance you mistyped the network password, this means you will have to manually reset the network

## Reset WiFi Credentials

1. Plug the raspi into ethernet
2. Get the ip address from your router or other method
3. Goto http://{ip}:8080/reset_network
4. Repeat setup instructions
