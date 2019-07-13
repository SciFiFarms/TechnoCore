#!/usr/bin/env bash

if cat /run/secrets/acme_env | grep "Not yet set." &> /dev/null
then
    echo "acme_env has not been set."
    exit 1
fi

eval "$(cat /run/secrets/acme_env)" &> /dev/null
# echo caused non-ascii chars to be printed."
printf "$ACME_DOMAIN"
exit 0
