#!/bin/bash
# TODO: Replace all the /dev/nulls in install.sh, vault.sh, and host.sh (Other places?). This should really be set in .env.
debug_output=/dev/null

# Make sure dependencies are met. 
# Source: https://askubuntu.com/questions/15853/how-can-a-script-check-if-its-being-run-as-root
if ! [ $(id -u) = 0 ]; then
   echo "Not running as root. Try running with sudo prepended to the command. "
   exit 1
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
