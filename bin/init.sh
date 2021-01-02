#!/usr/bin/env bash

export_envs() {
  local envFile=${1:-.env}
  local isComment='^[[:space:]]*#'
  local isBlank='^[[:space:]]*$'
  while IFS= read -r line; do
    [[ $line =~ $isComment ]] && continue
    [[ $line =~ $isBlank ]] && continue
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    export "${key}=${value}"
  done < <( cat "$envFile" )
}


set -a
    TECHNOCORE_LIB=/usr/local/lib/technocore
    TECHNOCORE_SERVICES=/var/lib/technocore

    # TODO: I have this nagging feeling that doing it like this will make .env wipe out existing env vars.  
    #       https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
    if [ -f "/mnt/technocore/.env" ]; then
        export_envs $TECHNOCORE_LIB/defaults.env
        export_envs "/mnt/technocore/.env"
        while read -r env; do 
            # Trim off the env var name and = char. 
            export_envs "/mnt/technocore/stacks/$(echo $env | sed "s/.*\?=\(.*\)/\1/")"
        # Have to pipe the input like this. Otherwise the loop creates a subprocess 
        # and varaibles don't get set. http://mywiki.wooledge.org/ProcessSubstitution
        done < <(env | grep "^LOAD_ENV")
        # Reloading the .env will allow those options to override the ones loaded by LOAD_ENV.
        export_envs "/mnt/technocore/.env"
    fi
set +a
