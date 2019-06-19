# Contributing to TechnoCore
## Contributing
My hope is that TechnoCore changes the world, but I can't do it alone. So thank you for considering contributing to TechnoCore. 

TechnoCore is a very new project and in need of lots of love. There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code, the list goes on and on. If you're looking for something to contribute, checkout the [open issues](https://github.com/SciFiFarms/TechnoCore/issues). If you have an idea that isn't in the issues, please make one! I'd love to heard about it. 

#### Table of contents:
- [Contributing to TechnoCore](#Contributing-to-TechnoCore)
  - [Contributing](#Contributing)
      - [Table of contents:](#Table-of-contents)
    - [\# TODO:](#TODO)
    - [Creating an issue](#Creating-an-issue)
      - [Labels](#Labels)
    - [Report a bug](#Report-a-bug)
  - [Community](#Community)
  - [Development](#Development)
    - [Overview](#Overview)
  - [Developer Environment](#Developer-Environment)
    - [Debugging (how to find out what went wrong)](#Debugging-how-to-find-out-what-went-wrong)
      - [Viewing Logs](#Viewing-Logs)
      - [Changing verbosity of logs](#Changing-verbosity-of-logs)
      - [Documentation Coming Soon](#Documentation-Coming-Soon)
    - [Finding things](#Finding-things)
    - [Working on an issue](#Working-on-an-issue)
    - [Run tests](#Run-tests)
    - [Conventions](#Conventions)

My goal is to be welcoming to newcomers and encourage diverse new contributors from all backgrounds. Please see the [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

### \# TODO:
I've littered ` TODO:` - always in caps - throughout the code base with little improvements that would make the code better. There are currently 80 something of these. If you [search](https://github.com/search?l=&q=org%3ASciFiFarms+%22TODO%3A%22+-extension%3A.js&type=Code) for that, you might just find something. Many of these are ripe for refactoring and I suspect would be a good place to start if you wanted a project that would help you learn how TechnoCore works, but in small bites. 
Unfortunately, GitHub's search is underwhelming and only shows the first two occurrences in a file. Running the utilities/dev-install.sh script (to clone all the TechnoCore repos) and then using your IDE to do a case sensitive search for "TODO:" will show you more results. I've found excluding .js files or the Home Assistant repo from the search to filter a lot of the noise as well. 

### Creating an issue

#### Labels
- **Duplicate**: There is already an open issue addressing the given issue. 
- **Good First Issue**: These issues are of small scope or don't require existing knowledge of TechnoCore to complete. At least, that's the idea; I find that often when I think a task will be easy, it isn't. 
- **Priority: 1**: Are essential for the first release of TechnoCore.
- **Priority: 2**: Are not critical to the functioning of TechnoCore, but would like to implement.
- **Priority: 3**: Would be nice to have, and I'm hoping someone in the community will implement. 
- **Type: Bug**
- **Type: Enhancement**
- **Type: Other**
- **Type: Question**

### Report a bug
When filing an issue, please answer these five questions:
1. What version of TechnoCore are you using 
2. What operating system and processor architecture are you using?
3. What steps do you take to produce the issue?
4. What did you expect to see?
5. What did you see instead?

If you find a security vulnerability, please email SpencerIsSuperAwesome@gmail.com rather than opening an issue. 

## Community
Currently, TechnoCore's only community is seen in the issues. While it is small, that works well. But if you have an interest in creating a place for chat or discussion, checkout https://github.com/SciFiFarms/TechnoCore/issues/29.

## Development
### Overview 
Below is a list of the projects that TechnoCore uses and links to more information about each one. 
Technocore's documentation on a technology is usually the websites I found helpful when setting up that service or feature. I plan to clean these up and add more TechnoCore specific information about the service. Currently, this is the only organized way to get to these pages.
The first 4 are all a regular user should need. 
- **[Home Assistant](https://www.home-assistant.io/)** - For viewing current status of sensors as well as their history. 
  - [Home-Assistant's Documentation](https://www.home-assistant.io/docs/)
  - [TechnoCore's documentation on Home Assistant](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_home-assistant.md)
  - [TechnoCore-Home-Assistant: Git repo](https://github.com/SciFiFarms/TechnoCore-Home-Assistant)
  - [TechnoCore-Home-Assistant: Docker Hub](https://hub.docker.com/r/scififarms/technocore-home-assistant)
- **[ESPHome](https://esphome.io/)** - Configures and flashes the ESP8266s and ESP32s.
  - [ESPHome's Documentation](https://esphome.io/)
  - [ESPHome's Getting Started](https://esphome.io/guides/getting_started_hassio.html#dashboard-interface) 
  - [ESPHome's Devices](https://esphome.io/index.html#devices)
  - [TechnoCore's documentation on ESPHome](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/esphome.md)
  - [TechnoCore-ESPHome: Git repo](https://github.com/SciFiFarms/TechnoCore-ESPHome)
  - [TechnoCore-ESPHome: Docker Hub](https://hub.docker.com/r/scififarms/technocore-esphome)
- **[Grafana](https://grafana.com/)** - Makes graphing data easy and beautiful. 
  - [Grafana's Documentation](https://grafana.com/docs/)
  - [Grafana Dashboards](https://grafana.com/dashboards)
  - [TechnoCore's documentation on Grafana](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/grafana.md)
  - [TechnoCore-Grafana: Git repo](https://github.com/SciFiFarms/TechnoCore-Grafana)
  - [TechnoCore-Grafana: Docker Hub](https://hub.docker.com/r/scififarms/technocore-grafana)
- **[Node-RED](https://nodered.org/)** - Can be thought of as the brain of TechnoCore. It is responsible for taking the input, be it sensor, or one of the 2,000+ nodes currently available, processes it using Javascript, and then adjusts switches, levels, and states accordingly.
  - [Node-RED's Documentation](https://nodered.org/docs/)
  - [TechnoCore's documentation on Node-RED](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_node-red.md)
  - [Great video on using Node-RED with Home Assistant](https://www.youtube.com/watch?v=dYN1Lp-XYKA)
  - [TechnoCore-Node-RED: Git repo](https://github.com/SciFiFarms/TechnoCore-Node-RED)
  - [TechnoCore-Node-RED: Docker Hub](https://hub.docker.com/r/scififarms/technocore-node-red)
- **[Jupyter](https://jupyter.org/)** - Provides data science and python capabilities 
  - [Jupyter's Documentation](https://jupyter.org/documentation)
  - [TechnoCore's documentation on Jupyter](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_jupyter.md)
  - [TechnoCore-Jupyter: Git repo](https://github.com/SciFiFarms/TechnoCore-Jupyter)
  - [TechnoCore-Jupyter: Docker Hub](https://hub.docker.com/r/scififarms/technocore-jupyter)
- **[NGINX](https://nginx.org/)** - Is the gateway to TechnoCore. All HTTP, HTTPS, and MQTT traffic gets forwarded by NGINX. 
  - [NGINX's Documentation](http://nginx.org/en/docs/)
  - [TechnoCore's documentation on NGINX](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_nginx.md)
  - [TechnoCore-NGINX: Git repo](https://github.com/SciFiFarms/TechnoCore-NGINX)
  - [TechnoCore-NGINX: Docker Hub](https://hub.docker.com/r/scififarms/technocore-nginx)
- **[Prometheus](https://prometheus.io/)** - Collects and stores metrics for all the services. Viewed through Grafana.
  - [Prometheus's Documentation](https://prometheus.io/docs/introduction/overview/)
  - [TechnoCore's documentation on Prometheus](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_prometheus.md)
  - [TechnoCore-Prometheus: Git repo](https://github.com/SciFiFarms/TechnoCore-Prometheus)
  - [TechnoCore-Prometheus: Docker Hub](https://hub.docker.com/r/scififarms/technocore-prometheus)
  - [Exporter: cAdvisor](https://github.com/google/cadvisor)
  - [Exporter: nextcloud-exporter](https://github.com/xperimental/nextcloud-exporter)
  - [Exporter: Node exporter](https://github.com/prometheus/node_exporter)
- **[Docker](https://www.docker.com/)** - TechnoCore would not be possible without Docker. It enables infrastructure as code allowing users to easily set up complicated stacks and developers to easily make changes. 
  - [Docker's Documentation](https://docs.docker.com/)
  - [TechnoCore's documentation on Docker](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_docker.md)
- **[Portainer](https://www.portainer.io/)** - Provides a GUI for Docker as well as the service responsible for initializing all the other services.
  - [Portainer's Documentation](https://portainer.readthedocs.io/en/stable/)
  - [TechnoCore's documentation on Portainer](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_portainer.md)
  - [TechnoCore-Portainer: Git repo](https://github.com/SciFiFarms/TechnoCore-Portainer)
  - [TechnoCore-Portainer: Docker Hub](https://hub.docker.com/r/scififarms/technocore-portainer)
- **[VerneMQ (MQTT Provider)](https://vernemq.com/)** - MQTT is the communication backbone of TechnoCore. It is what enables sensors to talk with services and services to talk with each other. 
  - [VerneMQ's Documentation](https://vernemq.com/docs/)
  - [TechnoCore's documentation on VerneMQ](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_vernemq.md)
  - [TechnoCore-VerneMQ: Git repo](https://github.com/SciFiFarms/TechnoCore-VerneMQ)
  - [TechnoCore-VerneMQ: Docker Hub](https://hub.docker.com/r/scififarms/technocore-vernemq)
- **[Vault](https://www.vaultproject.io/)** - Is the private key infrastructure that enables secure authentication and communication between devices, services, and browsers.
  - [Vault's Documentation](https://www.vaultproject.io/docs/)
  - [TechnoCore's documentation on Vault](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_vault.md)
  - [TechnoCore-Vault: Git repo](https://github.com/SciFiFarms/TechnoCore-Vault)
  - [TechnoCore-Vault: Docker Hub](https://hub.docker.com/r/scififarms/technocore-vault)
- **[Dogfish](https://github.com/dwb/dogfish)** - Enables the idea of migrations to the state of the service.
  - [TechnoCore's documentation on Dogfish](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_dogfish.md)
  - [TechnoCore Dogfish: Git repo](https://github.com/SciFiFarms/dogfish)
- **[acme.sh](https://github.com/Neilpang/acme.sh)** - Makes LetsEncrypt crazy easy to use.
  - [acme.sh's Documentation](https://github.com/Neilpang/acme.sh/wiki)
  - [TechnoCore's documentation on acme.sh](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_acme.sh.md)
- **[InfluxDB](https://www.influxdata.com/)** - Database back end for storing sensor data.
  - [InfluxDB's Documentation](https://docs.influxdata.com/influxdb/v1.7/)
  - [TechnoCore's documentation on InfluxDB](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_influxdb.md)
  - [TechnoCore-InfluxDB: Git repo](https://github.com/SciFiFarms/TechnoCore-InfluxDB)
  - [TechnoCore-InfluxDB: Docker Hub](https://hub.docker.com/r/scififarms/technocore-influxdb)
- **[PostgreSQL](https://www.postgresql.org/)** - Database back end for Home Assistant.
  - [PostgreSQL's Documentation](https://www.postgresql.org/docs/)
  - [TechnoCore's documentation on PostgreSQL](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_postgresql.md)
  - [TechnoCore-Home-Assistant-DB: Git repo](https://github.com/SciFiFarms/TechnoCore-Home-Assistant-DB)
  - [TechnoCore-Home-Assistant-DB: Docker Hub](https://hub.docker.com/r/scififarms/technocore-home-assistant-db)
- **[Loki](https://grafana.com/loki)** - Collects and stores logs. Like Prometheus.
  - [Loki's Documentation](https://github.com/grafana/loki#loki-like-prometheus-but-for-logs)
  - [TechnoCore's documentation on Loki](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/logs.md)
  - [TechnoCore-Loki: Git repo](https://github.com/SciFiFarms/TechnoCore-Loki)
  - [TechnoCore-Loki: Docker Hub](https://hub.docker.com/r/scififarms/technocore-loki)
- **[HUGO](https://gohugo.io/)** - HUGO powers TechnoCore's documentation. 
  - [HUGO's Documentation](https://gohugo.io/documentation/)
  - [TechnoCore's documentation on HUGO](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_docs.md)
  - [TechnoCore-Docs: Git repo](https://github.com/SciFiFarms/TechnoCore-Docs)
  - [TechnoCore-Docs: Docker Hub](https://hub.docker.com/r/scififarms/technocore-docs)
- **[Jekyll](https://jekyllrb.com/)** - Jekyll originally powered TechnoCore's documentation. 
  - [Jekyll's Documentation](https://jekyllrb.com/docs/)
  - [TechnoCore's documentation on Jekyll](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_docs.md)
  - [TechnoCore-Docs: Git repo](https://github.com/SciFiFarms/TechnoCore-Docs)
  - [TechnoCore-Docs: Docker Hub](https://hub.docker.com/r/scififarms/technocore-docs)
- **[PlatformIO (Flashing ESPs)](https://platformio.org/)** - The PlatformIO service allows for flashing ESPs and is triggered from Home Assistant.
  - [PlatformIO's Documentation](https://docs.platformio.org/)
  - [TechnoCore's documentation on PlatformIO](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_platformio.md)
  - [TechnoCore-PlatformIO: Git repo](https://github.com/SciFiFarms/TechnoCore-PlatformIO)
  - [TechnoCore-PlatformIO: Docker Hub](https://hub.docker.com/r/scififarms/technocore-platformio)
- **[yq](https://github.com/mikefarah/yq)** - Makes using yaml in bash possible.  
  - [yq's Documentation](http://mikefarah.github.io/yq/)
- **[Linux](https://www.linux.org/)** - The kernel everything is built to use.
  - [TechnoCore's documentation on Linux](https://github.com/SciFiFarms/TechnoCore-Docs/blob/master/pages/allthing/allthing_linux.md)
- **[espressif/ESP8266](https://espressif.com)** - The ESP8266 is a $5 WiFi chip that you can connect senors to.

## Developer Environment 

### Debugging (how to find out what went wrong)
#### Viewing Logs
The best way to view logs is via Grafana's Explore interafce. It's accessible from the menu on the left of Home Assistant. Alteratively, I also use `docker service logs -f SERVICE_NAME`
To get a list of the service names, run `docker service ls`
#### Changing verbosity of logs
- To increase logging verbosity in Node-RED, change node-red/data/settings.js logging: console: level to "trace".

#### Documentation Coming Soon
There will be more added to this section soon. Here is an outline of the topics to be added:
  - Setting up VS Code with TechnoCore(technocore-workspace.code-workspace)
  - Getting started via dev-setup.sh
  - Mounting local files into running services(.env)
  - Building the images yourself (utilities/clean.sh)
  - Debugging in Home Assistant, Node-RED, and VerneMQ (MQTT)
  - Changing verbosity of Home Assistant and VerneMQ. 
If you'd like to know about any of these before I get around to adding them, just let me know and I'll prioritize it. 

### Finding things
There are two places I'd recommend searching for things you might be looking for. 
  1. Run the ./utilities/dev-install.sh script to install the whole code base, and then use VS Code (Or your preferred IDE) to search through the workspace. 
    I've found this to be the most reliable search method, but doesn't get pull requests or issues. 
  2. [SciFiFarms' GitHub](https://github.com/search?q=org%3ASciFiFarms)
    This should find things in the code as well as what's documented in pull requests and issues. 

### Working on an issue
1. Fork the code
2. Commit your changes in your fork
3. Send a pull request with your changes

### Run tests
There aren't currently any tests written. I'd love to change that [#6](https://github.com/SciFiFarms/TechnoCore/issues/6). 

### Conventions
TechnoCore uses bash, c++, Python, and Javascript, so having one set of conventions doesn't make sense. Please use the conventions typical of the language being used. 
