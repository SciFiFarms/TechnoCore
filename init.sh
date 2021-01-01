#!/usr/bin/env sh

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

enable_docker () {
    # TODO: this assumes we the docker daemon can be interacted with systemctl - Update this to be more inclusive of all unix systems
    sudo systemctl enable docker
    sudo systemctl start docker
}

set_docker_permissions () {
    # Source: https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
    if ! getent group docker | grep -w "$USER" > /dev/null ; then
        # Used logname to get username before sudo: https://stackoverflow.com/questions/4598001/how-do-you-find-the-original-user-through-multiple-sudo-and-su-commands
        echo "Adding $(logname) to docker group"
        sudo usermod -a -G docker $(logname)
    fi
}

start_docker_swarm () {
    # Initialize the swarm if it isn't setup.
    # Used 2>&1 to include stderr in the pipe to grep as that is where the "Error reponse" 
    # would come from. See the following for more about redirection: https://stackoverflow.com/questions/2342826/how-to-pipe-stderr-and-not-stdout
    if sudo docker swarm ca 2>&1 | grep "Error response" &> /dev/null ; then
        echo "Initializing Docker Swarm"
        sudo docker swarm init > /dev/null
        until ! sudo docker swarm ca 2>&1 | grep "Error response" &> /dev/null ; do
            echo "Waiting for swarm to initilize."
            sleep 1
        done
    fi
}

install_docker () {
    if [ -z "$INSTALL_DOCKER" ]; then
        # Source: https://www.shellhacks.com/yes-no-bash-script-prompt-confirmation/
        read -p "Installing Docker. Do you wish to proceed (y or n)? " yn
    else
        yn=$INSTALL_DOCKER
    fi

    case $yn in
        [Yy]* ) curl -fsSL get.docker.com | sh;
            enable_docker
            start_docker_swarm
            set_docker_permissions "$@"
            ;;
        [Nn]* ) echo "Cannot run TechnoCore without Docker. Exitting."; exit;;
        * ) echo "Please answer y or n.";;
    esac
}

set -a
    TECHNOCORE_ROOT=$(pwd)
    TECHNOCORE_LIB=$TECHNOCORE_ROOT/lib
    TECHNOCORE_SERVICES=$TECHNOCORE_ROOT/services
    TECHNOCORE_DATA=$TECHNOCORE_ROOT/data

    # TODO: I have this nagging feeling that doing it like this will make .env wipe out existing env vars.  
    #       https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
    . "$TECHNOCORE_LIB/defaults.env"
    . "$TECHNOCORE_ROOT/.env"
    if [ ! -z "$LOAD_STACK" ]; then
        . "$TECHNOCORE_ROOT/stacks/$LOAD_STACK"
        . "$TECHNOCORE_ROOT/.env"
    fi
set +a

if ! command_exists docker; then
    install_docker "$@"
    echo "Finished installing Docker. Running TechnoCore."
fi
