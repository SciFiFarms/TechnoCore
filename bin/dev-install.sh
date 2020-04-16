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

# TODO: Add example.env to repo
# It may ultimately make more sense to do something more complicated so that
# .env files can be stacked. Something like docker-compose with multiple -f options.
# That way, any changes made upstream have a way of making it back to the running config
# without any human intervention. Can that be done with sourcing .env files in the right order?
# For now, this works. 
add_env_if_missing()
{
    if [ ! -f .env ]; then
        cp dev.env .env
        echo "Created .env file from example."
    else
        echo ".env already exists."
    fi
}

check_git_dependancy 
check_docker_dependancy
check_subrepo_dependancy

add_aliases_if_missing


add_env_if_missing

# Reload so that any changes made above get applied. 
source ~/.bashrc