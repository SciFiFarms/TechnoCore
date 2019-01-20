#!/usr/bin/env bash

# The deploy_dev_env script aims to install the TechnoCore development environment. 
# Each step is done idempotently so that should the environment change, the changes 
# incorporated via a single deploy_dev_env call. 

# TODO: Add cleanup component.
# TODO: Consider adding hosts references to 127.0.0.1 for the stack.

check_git_dependancy()
{
    # TODO: If git doesn't exist, throw an error.
    echo
    # TODO: Have this determine if I should use the https path, or the ssh path. 
}

check_docker_dependancy()
{
    # TODO: If docker doesn't exist, throw an error.
    echo
}

check_subrepo_dependancy()
{
    if ! git subrepo --version; then
        add_repo_if_missing git@github.com:ingydotnet/git-subrepo.git git-subrepo release/0.4.0 
        echo "Added suprepo."
    else
        echo "Subrepo already installed."
    fi
}

# Adds the repo if it is missing. 
# $1: The url of the repo to add
# $2: The location to add the repo
# $3 (optional): The branch to checkout.
add_repo_if_missing()
{
    # TODO: Pop args into named variables here. 
    # OR just figure out how to add the -b flag when set. 
    if [ ! -d "$2" ]; then
        git clone $1 $2 $3
        echo "Added $2 repo"
    else
        echo "$2 already exists. Will not overwrite repo."
    fi
}

add_aliases_if_missing()
{
    alias_path="$(pwd)/utilities/aliases.sh"
    # TODO: This check always adds the path :/.
    if ! grep -Fq ~/.bashrc "$alias_path"; then
        echo "source $alias_path" >> ~/.bashrc
        echo "Added source $alias_path to ~/.bashrc"
    else
        echo "$alias_path was already in ~/.bashrc, skipping."
    fi
}

# TODO: Add example.env to repo
# It may ultimately make more sense to do something more complicated so that
# .env files can be stacked. Something like docker-compose with multiple -f options.
# That way, any changes made upstream have a way of making it back to the running config
# without any human intervention. Can that be done with sourcing .env files in the right order?
# For now, this works. 
add_env_if_missing()
{
    if [ ! -f .env ]; then
        cp example.env .env
        echo "Created .env file from example."
    else
        echo ".env already exists."
    fi
}

check_git_dependancy 
check_docker_dependancy
check_subrepo_dependancy

add_aliases_if_missing

add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-Docs.git docs
add_repo_if_missing git@github.com:SciFiFarms/dogfish.git dogfish
add_repo_if_missing git@github.com:SciFiFarms/HA_Homie.git ha_homie
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-Home-Assistant.git home-assistant
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-Home-Assistant-DB.git home-assistant-db
add_repo_if_missing git@github.com:SciFiFarms/Homie.git homie
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-Node-RED.git node-red
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-NGINX.git nginx
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-esphomeyaml-Wrapper.git esphomeyaml-wrapper
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-Portainer.git portainer
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-Vault.git vault
add_repo_if_missing git@github.com:SciFiFarms/TechnoCore-VerneMQ.git vernemq

add_env_if_missing

# Reload so that any changes made above get applied. 
source ~/.bashrc