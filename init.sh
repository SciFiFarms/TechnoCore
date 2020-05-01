#!/usr/bin/env sh

install_docker () {
    # TODO: allow the user to explicitly say yes to instaling docker
    echo "Installing Docker. Press ctrl-c to quit"
    # Give the user time to respond
    sleep 5
    curl https://get.docker.com/ | sh
}

which docker

if [ $? -eq 1 ]
then
    install_docker
else
    docker --version | grep "Docker version"
    if [ $? -eq 1 ]
    then
        install_docker
    fi
fi


set -a
    TECHNOCORE_ROOT=$(pwd)
    TECHNOCORE_LIB=$TECHNOCORE_ROOT/lib
    TECHNOCORE_SERVICES=$TECHNOCORE_ROOT/services

    # TODO: add to path instead?
    #TECHNOCORE_BIN=$TECHNOCORE_ROOT/bin

    # TODO: I have this nagging feeling that doing it like this will make .env wipe out existing env vars.  
    #       https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
    . $TECHNOCORE_LIB/defaults.env
    . ./.env
set +a
