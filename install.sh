#!/bin/bash
# Test that docker exists.
# Test that your installing as root or sudo. 
# Check /etc/tls/certs and /etc/tls/keys, and maybe ca-cets and ca-keys. Load them if avalible. 

vault=vault.scifi.farm
ha=ha.scifi.farm
mqtt=mqtt.scifi.farm
ha_db=ha_db.scifi.farm
nr=nr.scifi.farm

# List of services 
declare -a services=($vault $ha $mqtt $ha_db $nr) 

# Add domains to hosts file.
for service in "${services[@]}"
do
    echo "Adding $service to /etc/hosts."
    if ! grep -q $service /etc/hosts; then
        echo "127.0.0.1 $service" >> /etc/hosts
    fi
done

# Put export uid commands in profiles.d
if [ ! -f /etc/profile.d/docker-uid.sh ]; then
    echo "export UID" >> /etc/profile.d/docker-uid.sh
    chmod +x /etc/profile.d/docker-uid.sh
    export UID
fi


# Have to figure out how to name builds.
docker-compose build .
docker stack deploy --config-file docker-compose.yaml althing
# Generate certs
# Put CA into browsers or use lets encrypt
# Maybe put a backup of 