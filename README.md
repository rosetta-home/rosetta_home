# Rosetta Home 2.0

Rosetta Home 2.0 is an open source Apache 2.0 licensed home automation system built with security and privacy in mind. This means it has an offline first mentality, no internet required. Cloud connectivity is optional for data backup and more in-depth data analysis. You are not locked into any one cloud provider. Out of the box we support encrypted MQTT backends on port `4883`. [Brood](https://github.com/rosetta-home/brood) provides all the necessary infrastructure for hosting your own cloud based backend.

It offers a zero-configuration installation, meaning it will attempt to auto-discover as many devices on your network as possible. The system works with a plethora of consumer products for lighting, HVAC, media playback, energy monitoring and weather monitoring. It also works with [CRT Labs](https://crtlabs.org) open source [IEQ (Indoor Environmental Quality) sensors](https://github.com/NationalAssociationOfRealtors/IndoorAirQualitySensor).

For an overview of the system, see the slides from [Erlang & Elixir Factory SF Bay 2017](https://docs.google.com/presentation/d/1ebwoJh2H1aQTldHATP0jEGBsT74Yr3dEMmRqTPQvQec/pub?start=false&loop=false&delayms=30000)

The system itself runs on a [Raspberry Pi](https://www.raspberrypi.org/) and utilizes several USB dongles to communicate with a multitude of devices over differing protocols. Network connectivity is provided over WiFi or ethernet.

For installation instructions please see the [installation instructions](/INSTALL.md)

**Grafana GUI**
![Grafana](/assets/rosetta-home-grafana.png)

Here are some screen shots of the LAN interface.

**IEQ**

![Scrolling Graphs](/assets/RosettaHome2.0.gif)


**Lighting Control**

![Lights](/assets/lights.png)

**HVAC Control**

![HVAC](/assets/hvac.png)

**Media Player**

![Media Player](/assets/media_player.png)

**Weather Stations**

![Weather Stations](/assets/weather_stations.png)
