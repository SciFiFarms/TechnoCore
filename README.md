# TechnoCore
Fundamentally TechnoCore is a stack built to support Home Assistant. It strives to make IoT cheap, easy, and secure. Ultimately, it will be used to run a vertical farm. You can see more about how its done in the [Overview](https://github.com/SciFiFarms/TechnoCore/blob/master/CONTRIBUTING.md#overview).

#### Table of contents:
- [TechnoCore](#technocore)
      - [Table of contents:](#table-of-contents)
  - [What to know before getting started](#what-to-know-before-getting-started)
    - [Status of TechnoCore:](#status-of-technocore)
    - [Dependencies](#dependencies)
    - [Roadmap](#roadmap)
  - [Where to ask questions](#where-to-ask-questions)
  - [How to install TechnoCore](#how-to-install-technocore)
  - [How to use TechnoCore](#how-to-use-technocore)
    - [Service Locations](#service-locations)
    - [Home Assistant](#home-assistant)
    - [ESPHome](#esphome)
    - [Configuring Your TechnoCore instance](#configuring-your-technocore-instance)
  - [Come help!](#come-help)
  - [Authors](#authors)
  - [Acknowledgements](#acknowledgements)
  - [License](#license)
    
## What to know before getting started
### Status of TechnoCore: 
TechnoCore is currently in beta. The infrastructure is done, but there are still some sensors that need to be integrated into the esp8266 firmware. 
If you try it and run into issues, please open a [new issue](https://github.com/SciFiFarms/TechnoCore/issues/new). I'd love to help get it working.
### Dependencies 
1. Git 
2. Docker - Will be installed automatically if not present. 
3. Operating System
   1. Linux - I'm running under Fedora 29. This should work in other distributions. 
   2. OS X - At one point, it was working with OS X. A lot has changed since then, and I'd expect some minor issues. 
   3. Windows - Not currently supported. Once the installer moves to within the swarm, it should work OK. Checkout https://github.com/SciFiFarms/TechnoCore/issues/10 for more information.
   4. Pi - Would like to eventually support. https://github.com/SciFiFarms/TechnoCore/issues/8
4. Duck DNS
  In order to provide a trusted connection to TechnoCore, I've utilized [DuckDNS.org](https://www.duckdns.org/) and [LetsEncrypt](https://letsencrypt.org/) to generate trusted TLS certificates. 
  You'll need to provide your DuckDNS token and domain as part of the installation. DuckDNS allows you to login using GitHub, Reddit, Google, or Twitter accounts, so you shouldn't need to create a new account. 
  If you'd rather use a self signed cert, pass in the --dev flag to the installer `./install.sh --dev`. Everything will work, but you'll have to access the services directly rather than through the Home Assistant interface. 
### Roadmap 
There is always something in the works, so it may be worth checking out the [TechnoCore Project](https://github.com/orgs/SciFiFarms/projects/1) to see what features are being addressed.

## Where to ask questions
One of my biggest hopes for this project is that it gets used by others. So if you have any questions or run into any trouble using the software, I would really like to know about it. Feel free to open a [new issue](https://github.com/SciFiFarms/TechnoCore/issues/new) with your question or problem. Alternatively, you can email me at SpencerIsSuperAwesome@gmail.com.

## How to install TechnoCore
~~~
git clone https://github.com/SciFiFarms/TechnoCore.git technocore
cd technocore
sudo ./install.sh
~~~

## How to use TechnoCore
### Service Locations
The best way to access TechnoCore is through the Home Assistant interface. These services will be listed on the left side of the page. 
You can access the Home Assistant interface by navigating to the DuckDNS domain that you provided the installer. It should also be repeated for you at the end of the installation of TechnoCore. This should look something like: https://technocore.duckdns.org/. 
If you'd like to access the services directly rather than through Home Assistant, the following are the paths you can use to access specific services. 
- Home Assistant: /
    - Displays current sensor statuses.
    - Displays sensor histories.
    - Turn switches on and off.
    - [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- ESPHome: :6052/
    - Configures and flashes ESP8266s and ESP32s. 
    - [ESPHome Documentation](https://esphome.io/)
- Node-RED: /node_red/ 
    - The business logic is built with Node-RED.
    - [Node-RED Documentation](https://nodered.org/docs/)
- Portainer: /portainer/ 
    - This gives you a GUI to see Docker though.  
    - [Portainer Documentation](https://portainer.readthedocs.io)
- Docs: /docs/ 
    - These are my notes, links, and instructions on each service. 
    - The best way to view the useful docs is to reference the [Overview table](https://github.com/SciFiFarms/TechnoCore/blob/master/CONTRIBUTING.md#overview).
    - The docs aren't very usable as a cohesive site. This has been my dumping grounds for all my thoughts for the last year, and thus are in need of some serious reorganization. See https://github.com/SciFiFarms/TechnoCore-Docs/issues/2 for more information. 
You can find out more about these services, along with the rest of the stack, in the [Overview](https://github.com/SciFiFarms/TechnoCore/blob/master/CONTRIBUTING.md#overview) in (CONTRIBUTING.md)[https://github.com/SciFiFarms/TechnoCore/blob/master/CONTRIBUTING.md]. 
Note: If you're using the developer install (`sudo ./install.sh --dev`), then it's likely accessing these through the Home Assistant interface won't work and you'll have to navigate to them directly. 

### Home Assistant
TechnoCore is a stack built to support Home Assistant, so to it's worth checking out the [Home Assistant Documentation](https://www.home-assistant.io/docs/) to get an idea of what TechnoCore and Home Assistant can do. 

### ESPHome
ESPs are the eyes and ears of TechnoCore. They aren't mandatory, but I'd highly recommend looking around [ESPHome's Documentation](https://esphome.io/) to see what is possible and how it works. 
Note: ESPHome is the most recent addition to TechnoCore, and I'm still exploring how to manage the ESPs in a sane and DRY way. Here are the methods I've employed:
  - Mounted the /config folder to a folder on the server, and then used NextCloud to sync changes between my local machine and the server. 
    This is my current solution. 
  - Mounted the /config folder to a folder on the server, and then used sshfs to mount that folder on my local machine. To do this, you'll need to setup passwordless ssh to your server, and the add something like the following to your /etc/fstab:
    ```technocore@technocore:/home/technocore/technocore/esphomeyaml/config /home/spencer/src/technocore/hals fuse.sshfs noauto,x-systemd.automount,_netdev,users,idmap=user,allow_other,reconnect 0 0```
    This worked OK when I was on the local network, but broke when I left the network. 
  - Used the text editor from within ESPHomeYaml. This worked OK, but doesn't have a way of editing files in folders, nor of creating symlinks. 

### Configuring Your TechnoCore instance
You can configure TechnoCore via the .env file. All available settings should already be set in there, so you can see everything that is settable there. Once you make a change you'll need to run the following from your TechnoCore directory:
```
deploy technocore
```
where `techonocore` is your $stack_name from the .env file. The default is `technocore`. 

## Come help!
I am excited about TechnoCore and would love it if you joined me in building it. It's a pretty new project so there is a lot to do, and many things that don't involve code. Below is a list of pages to check out if you're interested in helping out. If you have an idea that isn't addressed, please open an issue; I'd love to hear about it!
- **[Contributing](CONTRIBUTING.md#contributing)**
  - **[Creating an issue](CONTRIBUTING.md#creating-an-issue)**
    - **[Labels](CONTRIBUTING.md#labels)**
  - **[Report a bug](CONTRIBUTING.md#report-a-bug)**
- **[Community](CONTRIBUTING.md#community)**
- **[Development](CONTRIBUTING.md#development)**
  - **[Overview](CONTRIBUTING.md#overview)**
  - **[Developer Environment](CONTRIBUTING.md#developer-environment)**
  - **[Debugging](CONTRIBUTING.md#debugging-how-to-find-out-what-went-wrong)**
    - **[Viewing Logs](CONTRIBUTING.md#viewing-logs)**
    - **[Changing verbosity of logs](CONTRIBUTING.md#changing-verbosity-of-logs)**
  - **[Documentation Coming Soon](#documentation-coming-soon)**
  - **[Finding things](#finding-things)**
  - **[Working on an issue](CONTRIBUTING.md#working-on-an-issue)**
  - **[Run tests](CONTRIBUTING.md#run-tests)**
  - **[Conventions](CONTRIBUTING.md#conventions)**
- **[Code of Conduct](CODE_OF_CONDUCT.md)**

## Authors
* **Spencer Hachmeister** - *Initial work*
See also the list of [contributors](https://github.com/SciFiFarms/TechnoCore/contributors) who participated in this project.

## Acknowledgements
If you were to compare the number of lines of code unique to TechnoCore vs the projects that make up TechnoCore, it would be clear my contribution has been a drop in the ocean. The real credit has to go to all the folks creating open source software; without which, TechnoCore would not be possible.
More specifically, I'd like to thank everyone who has worked on the following projects:
- **[Home Assistant](https://www.home-assistant.io/)** for making TechnoCore user friendly. Home Assistant makes seeing current statuses, history, and interacting with the devices easy.
- **[esphomelib](https://esphomelib.com/)** for running my ESP8266s. \*esphomeyaml and/or ESP8266s are not *necessary* for TechnoCore. All that is required are devices that can communicate using the MQTT protocol.
- **[Node-RED](https://nodered.org/)** for allowing an intuitive way to program the Internet of Things. Because of this, Node-RED is used to implement all the business logic.
- **[Portainer](https://portainer.io/)** for making Docker approachable. 
- **[Docker](https://www.docker.com/)** for being the glue that brings everything together. Without Docker, sharing this project would not be feasible and be tricky to maintain. Docker makes TechnoCore possible.
- **[Jekyll](https://jekyllrb.com/)** for powering TechnoCore's documentation. 
- **[NGINX](https://nginx.org/)** for being the gateway to TechnoCore. 
- **[VerneMQ](https://vernemq.com/)** for being the communication backbone of TechnoCore.  
- **[Vault](https://www.vaultproject.io/)** for the private key infrastructure that enables secure authentication and communication between devices, services, and browsers.
- **[Dogfish](https://github.com/dwb/dogfish)** for enabling migrations in the services.
- **[acme.sh](https://github.com/Neilpang/acme.sh)** for making LetsEncrypt crazy easy. 
- **[PostgreSQL](https://www.postgresql.org/)** for storing the data; in the world today, data is worth more than gold.
- **[PlatformIO](https://platformio.org/)** for flashing ESPs.
- **[yq](https://github.com/mikefarah/yq)** for making yaml in bash possible. 
- **[Linux](https://www.linux.org/)** for being the OS running TechnoCore.
- **[Espressif/ESP8266](https://www.espressif.com/)** for being the easiest and cheapest way to run many sensors.
- **[DuckDNS](https://www.duckdns.org/)** for making using LetsEncrypt simple, as well as providing dynamic DNS. The free service is much appreciated.
- **[LetsEncrypt](https://letsencrypt.org/)** for automating security and encrypting the web. 
- **[Open Agriculture Initiative](https://www.media.mit.edu/groups/open-agriculture-openag/overview/)** - When I discovered their **M**inimum **V**iable **P**roduct, I started building it that week. It was the blueprint that got me started. TechnoCore is solving a different problem and takes a different approach accordingly, and Open Ag deserve credit for being the project that kicked it all off.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
