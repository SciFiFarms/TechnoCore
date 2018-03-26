# Road map
These tasks will eventually make their way to issues with more details on what needs to get done. In the mean time, if you see something you are curious about or might like to work on, please create an issue for it and I will make a point to fill in the details ASAP. Alternatively, you can email me at SpencerIsSuperAwesome@gmail.com. 

If you have ideas for other features to add, I'd love to hear about them! Please create a new issue with a [feature request] tag.

- **Priority 1** - are essential for the first release of Althing.
- **Priority 2** - are not critical to the functioning of Althing, but would like to implement.
- **Priority 3** - would be nice to have, and I'm hoping someone in the community will implement. 

## Priority 1
- Finish installer
- Secure MQTT communication
    - Implement TLS authentication
    - Encrypt traffic via TLS
- Automate ESP8266 provisioning
- Script to create Homie config and send it to device.
- Create Node-RED flows for an autonomous farm.
- Proxy to redirect based on URL rather than the port
    - [Ngix Proxy](https://github.com/jwilder/nginx-proxy)
- Tests
    - Look into a testing framework for MQTT tests. 

## Priority 2
- Health status
    - Report health status of devices and services. 
    - Maybe find an inventory/device management system that supports health checks. 
- Over The Air updates for ESP8266s.
    - Homie already supports OTA updates; just have to figure out how to set it up.
- Support Pi installation
    - Will need to get or generate ARM containers. Everything else *should* work.
- Support Windows installation
    - Will need to create powershell install script. 
- Node-RED SMS and email alerts
- Node-RED flow to automatically add new devices to Home Assistant
- Create Node-RED flows for a smart house.
- Inventory management 
    - Track devices, sensors, and configurations
- Set up Docker Hub repository with Althing images. 

## Priority 3
- Real time graphing
    - [D3](https://d3js.org/)
- Configify sensors
    - Container with /dev/usb0 mounted
    - User Interface to configure ESP8266 for sensors, WiFI, and MQTT communication
    - Backend to store configurations
    - Add configurations to Home Assistant
