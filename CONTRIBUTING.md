# Contributing to Althing :D
#### Table of contents:
- [Contributing](#contributing)
    - [Creating an issue](#creating-an-issue)
        - [Labels](#labels)
    - [Report a bug](#report-a-bug)
    - [Working on an issue](#working-on-an-issue)
    - [Code review process](#code-review-process)
    - [Committing code](#committing-code)
    - [Conventions](#conventions)
- [Development](#development)
    - [Overview](#overview)
    - [Developer Environment](#developer-environment)
    - [Debug](#debug)
    - [Run tests](#run-tests)
- [Community](#community)

## Contributing
My hope is that Althing changes the world, but I can't do it alone. So thank you for considering contributing to Althing. 

Althing is a very new project and in need of lots of love. There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code, the list goes on and on. If you're looking for something to contribute, checkout the [open issues](https://github.com/SciFiFarms/althing/issues). If you have an idea that isn't in the issues, please make one! I'd love to heard about it. 

My goal is to be welcoming to newcomers and encourage diverse new contributors from all backgrounds. Please see the [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

### Creating an issue

#### Labels
- **Duplicate**: There is already an open issue addressing the given issue. 
- **Good First Issue**: These issues are of small scope or don't require existing knowledge of Althing to complete. At least, that's the idea; I find that often when I think a task will be easy, it isn't. 
- **Priority: 1**: Are essential for the first release of Althing.
- **Priority: 2**: Are not critical to the functioning of Althing, but would like to implement.
- **Priority: 3**: Would be nice to have, and I'm hoping someone in the community will implement. 
- **Type: Bug**
- **Type: Enhancement**
- **Type: Other**
- **Type: Question**

### Report a bug
When filing an issue, please answer these five questions:
1. What version of Althing are you using 
2. What operating system and processor architecture are you using?
3. What steps do you take to produce the issue?
4. What did you expect to see?
5. What did you see instead?

If you find a security vulnerability, please email SpencerIsSuperAwesome@gmail.com rather than opening an issue. 

### Working on an issue
For something that is bigger than a one or two line fix:
1. Create your own fork of the code
2. Do the changes in your fork
3. If you like the change and think the project could use it, send a pull request.
    - Each pull request should implement one feature or bugfix.

### Code review process
I will review pull requests regularly. If the project grows, I will form a more formal review process and involve others who wish to help maintain Althing. 

### Committing code
I'd like to be able to trace commits back to the discussion in issues. 
To support this, please begin your commit messages with:
- #[issue number being addressed] if your commit addresses an open issue. If it addresses more than one issue #comma,#seperate,#the,#list.
- #none if there isn't an open issue, but you'd still like to open a pull request. 
- #documentation if it just updates to documentation or a typo in the code. 
- #typo if you're implementing a 1 or 2 line change that isn't addressed in any open issues.

### Conventions
 Althing uses a wide variety of languages, so having one set of conventions doesn't make sense. Please use the conventions typical of the language being used. 

## Development
### Overview 
The open source projects that are currently being used are:
- **[Docker](https://www.docker.com/)** - Althing would not be possible without Docker. It enables infrastructure as code allowing users to easily set up complicated stacks and developers to easily make changes. 
- **[Rabbit MQ](https://www.rabbitmq.com/)** - MQTT is the communication backbone of Althing. It is what enables sensors to talk with services and services to talk with each other. 
- **[Node-RED](https://nodered.org/)** - Can be thought of as the brain of Althing. It is responsible for taking the input, be it sensor, or one of the 2,000+ nodes currently available, processes it using Javascript, and then adjusts switches, levels, and states accordingly.
- **[Home Assistant](https://www.home-assistant.io/)** - For viewing current status of sensors as well as their history. 
- **[PostgreSQL](https://www.home-assistant.io/)** - Database back end for Home Assistant.
- **[Vault](https://www.vaultproject.io/)** - Is the private key infrastructure that enables secure authentication and communication between devices, services, and browsers.
- **[Homie for ESP8266](https://github.com/marvinroger/homie-esp8266)** - This is the framework being used to run the ESP8266s. Homie and/or ESP8266s are not *necessary* for Althing. All that is required are devices that can communicate using the MQTT protocol. 
- **[espressif/ESP8266](https://espressif.com)** - The ESP8266 is a $5 WiFi chip that you can connect senors to.

### Developer Environment 
Right now, the only way to run Althing is by building the images yourself. This gives you access to everything you'll need to work on Althing. This will not always be the case: [#11](https://github.com/SciFiFarms/althing/issues/11)

### Debug
The best way I've found to debug so far is using `docker service logs SERVICE_NAME`
To get a list of the service names, run `docker service ls`

### Run tests
There aren't currently any tests written. I'd love to change that [#6](https://github.com/SciFiFarms/althing/issues/6). 

## Community
Currently, Althing's only community is seen in the issues. While it is small, that works well. But if you have an interest in creating a place for chat or discussion, feel free to get ahold of me SpencerIsSuperAwesome@gmail.com