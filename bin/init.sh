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
    eval "export ${key}=\"$(echo \${value})\""
  done < <( cat "$envFile" )
}


set -a
    TECHNOCORE_LIB=/usr/local/lib/technocore
    TECHNOCORE_SERVICES=/var/lib/technocore

    # TODO: I have this nagging feeling that doing it like this will make .env wipe out existing env vars.  
    #       https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
    if [ -f ".env" ]; then
        export_envs $TECHNOCORE_LIB/defaults.env
        export_envs "$TECHNOCORE_SERVICES/technocore/.env"
        if [ ! -z "$LOAD_STACK" ]; then
            export_envs "$TECHNOCORE_SERVICES/technocore/$LOAD_STACK"
        fi
    fi
set +a
