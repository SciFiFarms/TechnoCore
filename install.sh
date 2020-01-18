#!/bin/bash
# TODO: Replace all the /dev/nulls in install.sh, vault.sh, and host.sh (Other places?). This should really be set in .env.
debug_output=/dev/null

# Add user permission to use docker if not already setup.
# https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
if getent group docker | grep -w "$USER" > /dev/null ; then
    # Used logname to get username before sudo: https://stackoverflow.com/questions/4598001/how-do-you-find-the-original-user-through-multiple-sudo-and-su-commands
    echo "Adding $(logname) to docker group"
    usermod -a -G docker $(logname)
fi

# Initialize the swarm if it isn't setup.
# Used 2>&1 to include stderr in the pipe to grep as that is where the "Error reponse" 
# would come from. See the following for more about redirection: https://stackoverflow.com/questions/2342826/how-to-pipe-stderr-and-not-stdout
if docker swarm ca 2>&1 | grep "Error response" &> /dev/null ; then
    echo "Initializing Docker Swarm"
    docker swarm init > /dev/null
fi

add_aliases_if_missing()
{
    local alias_path="$(pwd)/utilities/aliases.sh"
    local home_folder="$(getent passwd $SUDO_USER | cut -d: -f6)"
    if ! grep -Fq "$alias_path" ${home_folder}/.bashrc ; then
        echo "source $alias_path" >> ${home_folder}/.bashrc
        echo "Added source $alias_path to ${home_folder}/.bashrc"
    #else
    #    echo "aliases.sh was present in ${home_folder}/.bashrc, skipping addition."
    fi
}
add_aliases_if_missing

# In ubuntu, that needs to install libnss3-tools, which provides certutil
# TODO: Would like to install LetsEncrypt's testing server CAs. 
add_CA_to_firefox

echo -e "\n\n\nFinished initializing ${stack_name:-technocore}."
echo "You may now use https://${hostname_trimmed}/ to access your ${stack_name:-technocore} instance."
