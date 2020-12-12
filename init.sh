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
    if docker swarm ca 2>&1 | grep "Error response" &> /dev/null ; then
        echo "Initializing Docker Swarm"
        docker swarm init > /dev/null
    fi
}

install_docker () {
    # Source: https://www.shellhacks.com/yes-no-bash-script-prompt-confirmation/
    read -p "Installing Docker. Do you wish to proceed (y or n)? " yn
    case $yn in
        [Yy]* ) curl -fsSL get.docker.com | sh;
            enable_docker
            set_docker_permissions
            start_docker_swarm
            ;;
        [Nn]* ) echo "Cannot run TechnoCore without Docker. Exitting."; exit;;
        * ) echo "Please answer y or n.";;
    esac
}


if ! command_exists docker; then
    install_docker
    echo "Finished installing Docker. Running TechnoCore."
fi

set -a
    TECHNOCORE_ROOT=$(pwd)
    TECHNOCORE_LIB=$TECHNOCORE_ROOT/lib
    TECHNOCORE_SERVICES=$TECHNOCORE_ROOT/services

    # TODO: I have this nagging feeling that doing it like this will make .env wipe out existing env vars.  
    #       https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
    . "$TECHNOCORE_LIB/defaults.env"
    . "./.env"
set +a
