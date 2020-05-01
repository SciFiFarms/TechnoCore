#!/usr/bin/env sh

install_docker () {
    while true; do
        read -p "Installing Docker. Do you wish to proceed? " yn
        case $yn in
            [Yy]* ) curl https://get.docker.com/ | sh;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
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
