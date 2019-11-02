#!/usr/bin/env sh

set -a
    TECHNOCORE_LIB=/usr/local/lib/technocore
    TECHNOCORE_SERVICES=/var/lib/technocore

    # TODO: I have this nagging feeling that doing it like this will make .env wipe out existing env vars.  
    #       https://gist.github.com/judy2k/7656bfe3b322d669ef75364a46327836
    if [ -f ".env" ]; then
        . $TECHNOCORE_LIB/defaults.env
        . .env
    fi
set +a
