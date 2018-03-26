# Althing
Althing is a 100% open source IoT platform for DIYers and businesses that care about security and privacy. Althing does this by utilizing existing open source IoT microservices in a Docker swarm. Ultimately, Althing is being designed to support an autonomous farm.

## What to know before getting started
1. What you see is a working proof of concept; it takes some manual configuration to get the containers set up appropriately, and those steps have not been documented. Instead, they are being worked into the installer. 
1. Althing depends on Docker being installed. 
2. Althing isn't feature complete, so it may be worth checking out the [ROADMAP.md](ROADMAP.md) to see what is coming. 

## Where to ask questions
One of my biggest hopes for this project is that it gets used by others. So if you have any questions or run into any trouble using the software, I would really like to know about it. Feel free to open a new issue with your question or problem. Alternatively, you can email me at SpencerIsSuperAwesome@gmail.com. 

## How to install Althing
~~~
git clone https://github.com/SciFiFarms/althing.git
cd althing
sudo ./install.sh
~~~

## How to use Althing
Once it is running, you should be able to view the containers by visiting the following locations in your browser.
- Home Assistant [https://127.0.0.1:8123]
    - Displays current sensor statuses.
    - Displays sensor histories.
    - Turn switches on and off.
    - The default password is "welcome". 
    - [Home Assistant Documentation](https://www.home-assistant.io/docs/)
- Node-RED [https://127.0.0.1:1880]
    - The business logic is built with Node-RED. 
    - [Node-RED Documentation](https://nodered.org/docs/)
- EMQTT [https://127.0.0.1:8080]
    - [EMQTT Documentation](http://emqtt.io/docs/v2/index.html)

Althing should start automatically. If it does not, you can start it with the following command.
~~~
docker stack deploy --compose-file docker-compose.yaml althing
~~~

## Come help!
I am excited about Althing and would love it if you joined me in building it. It's a pretty new project so there is a lot to do, and many things that don't involve code. Below is a list of pages to check out if you're interested in helping out. If you have an idea that isn't addressed, please open an issue; I'd love to hear about it! 
- **[Contributing](CONTRIBUTING.md)** 
- **[Road map](ROADMAP.md)**
- **[Code of Conduct](CODE_OF_CONDUCT.md)** 

## Bug reporting
If you run into a bug, please open an issue. In that issue, please include answers to the following questions:
>    1. What version of Docker are you using?
>    2. What OS are you using?
>    3. What steps are required to reproduce the issue?
>    4. What actually happened?
>    5. What did you expect to happen?

## Authors
* **Spencer Hachmeister** - *Initial work*
See also the list of [contributors](https://github.com/SciFiFarms/althing/contributors) who participated in this project.

## Acknowledgements 
If you were to compare the number of lines of code unique to Althing vs the projects that make up Althing, it would be clear my contribution has been a drop in the ocean. The real credit has to go to all the folks creating open source software; without which, Althing would not be possible. 
More specifically, I'd like to thank everyone who has worked on the following projects:
- **Docker** for being the glue that brings everything together. Without Docker, sharing this project would not be feasible and be tricky to maintain. Docker makes Althing possible. 
- **Open Ag** - When I discovered their **M**inimum **V**iable **P**roduct, I started building it that week. It was the blueprint that got me started. Althing is solving a different problem and takes a different approach accordingly, and Open Ag deserve credit for being the project that kicked it all off.
- **EMQTT** for being the communication backbone of Althing.  
- **Node-RED** for allowing an intuitive way to program the Internet of Things. Because of this, Node-RED is used to implement all the business logic. 
- **Home Assistant** for making Althing user friendly. Home Assistant makes seeing current statuses, history, and interacting with the devices easy. 
- **Postgres** for storing the data; in the world today, data is worth more than gold.
- **Vault** for the private key infrastructure that enables secure authentication and communication between devices, services, and browsers.
- **Linux** for being the OS running Althing.
- **Espressif/ESP8266** for being the easiest and cheapest way to run many sensors. 
- **Homie** for running my ESP8266s. \*Homie and/or ESP8266s are not *necessary* for Althing. All that is required are devices that can communicate using the MQTT protocol. 

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details