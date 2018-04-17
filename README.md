# Althing
Althing is a 100% open source IoT platform for DIYers and businesses that care about security and privacy. Althing does this by utilizing existing open source IoT microservices in a Docker swarm. Ultimately, Althing is being designed to support an autonomous farm.

#### Table of contents:
- [What to know before getting started](#what-to-know-before-getting-started)
- [Where to ask questions](#where-to-ask-questions)
- [How to install Althing](#how-to-install-althing)
- [How to use Althing](#how-to-use-althing)
- [Come help!](#come-help)
- [Authors](#authors)
- [Acknowledgements](#acknowledgements)
- [License](#license)
## What to know before getting started
1. What you see is a working proof of concept; it hasn't been tested. But if you try it and run into issues, feel free to open a [new issue](https://github.com/SciFiFarms/althing/issues/new). I'd love to help get it working. 
1. Althing depends on Docker being installed. 
1. Althing isn't feature complete, so it may be worth checking out the [issues](https://github.com/SciFiFarms/althing/issues) to see what is coming. 

## Where to ask questions
One of my biggest hopes for this project is that it gets used by others. So if you have any questions or run into any trouble using the software, I would really like to know about it. Feel free to open a [new issue](https://github.com/SciFiFarms/althing/issues/new) with your question or problem. Alternatively, you can email me at SpencerIsSuperAwesome@gmail.com. 

## How to install Althing
~~~
git clone https://github.com/SciFiFarms/althing.git
cd althing
sudo ./install.sh
~~~

## How to use Althing
Once it is running, you should be able to view the containers by visiting the following locations in your browser.
- Home Assistant [https://127.0.0.1:8123](https://127.0.0.1:8123)
    - Displays current sensor statuses.
    - Displays sensor histories.
    - Turn switches on and off.
    - The default password is "welcome". 
    - [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- Node-RED [https://127.0.0.1:1880](https://127.0.0.1:1880)
    - The business logic is built with Node-RED. 
    - [Node-RED Documentation](https://nodered.org/docs/)
- Rabbit MQ [https://127.0.0.1:15672](https://127.0.0.1:15672)
    - [Rabbit MQ Documentation](https://www.rabbitmq.com/documentation.html)

Althing should start automatically. If it does not, you can start it with the following command.
~~~
docker stack deploy --compose-file docker-compose.yaml althing
~~~

## Come help!
I am excited about Althing and would love it if you joined me in building it. It's a pretty new project so there is a lot to do, and many things that don't involve code. Below is a list of pages to check out if you're interested in helping out. If you have an idea that isn't addressed, please open an issue; I'd love to hear about it! 
- **[Contributing](CONTRIBUTING.md#contributing)**
    - **[Creating an issue](CONTRIBUTING.md#creating-an-issue)**
        - **[Labels](CONTRIBUTING.md#labels)**
    - **[Report a bug](CONTRIBUTING.md#report-a-bug)**
    - **[Working on an issue](CONTRIBUTING.md#working-on-an-issue)**
    - **[Code review process](CONTRIBUTING.md#code-review-process)**
    - **[Committing code](CONTRIBUTING.md#committing-code)**
    - **[Conventions](CONTRIBUTING.md#conventions)**
- **[Development](CONTRIBUTING.md#development)**
    - **[Overview](CONTRIBUTING.md#overview)**
    - **[Developer Environment](CONTRIBUTING.md#developer-environment)**
    - **[Debug](CONTRIBUTING.md#debug)**
    - **[Run tests](CONTRIBUTING.md#run-tests)**
- **[Community](CONTRIBUTING.md#community)**
- **[Code of Conduct](CODE_OF_CONDUCT.md)** 

## Authors
* **Spencer Hachmeister** - *Initial work*
See also the list of [contributors](https://github.com/SciFiFarms/althing/contributors) who participated in this project.

## Acknowledgements 
If you were to compare the number of lines of code unique to Althing vs the projects that make up Althing, it would be clear my contribution has been a drop in the ocean. The real credit has to go to all the folks creating open source software; without which, Althing would not be possible. 
More specifically, I'd like to thank everyone who has worked on the following projects:
- **[Docker](https://www.docker.com/)** for being the glue that brings everything together. Without Docker, sharing this project would not be feasible and be tricky to maintain. Docker makes Althing possible. 
- **[Open Agriculture Initiative](https://www.media.mit.edu/groups/open-agriculture-openag/overview/)** - When I discovered their **M**inimum **V**iable **P**roduct, I started building it that week. It was the blueprint that got me started. Althing is solving a different problem and takes a different approach accordingly, and Open Ag deserve credit for being the project that kicked it all off.
- **[Rabbit MQ](https://www.rabbitmq.com)** for being the communication backbone of Althing.  
- **[Node-RED](https://nodered.org/)** for allowing an intuitive way to program the Internet of Things. Because of this, Node-RED is used to implement all the business logic. 
- **[Home Assistant](https://www.home-assistant.io/)** for making Althing user friendly. Home Assistant makes seeing current statuses, history, and interacting with the devices easy. 
- **[PostgreSQL](https://www.postgresql.org/)** for storing the data; in the world today, data is worth more than gold.
- **[Vault](https://www.vaultproject.io/)** for the private key infrastructure that enables secure authentication and communication between devices, services, and browsers.
- **[Linux](https://www.linux.org/)** for being the OS running Althing.
- **[Espressif/ESP8266](https://www.espressif.com/)** for being the easiest and cheapest way to run many sensors. 
- **[Homie for ESP8266](https://github.com/marvinroger/homie-esp8266)** for running my ESP8266s. \*Homie and/or ESP8266s are not *necessary* for Althing. All that is required are devices that can communicate using the MQTT protocol. 

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details