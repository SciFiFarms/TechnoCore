
# Add domains to hosts file.
# TODO: It would be better to accomplish this task in a way that is shared accross the network. mDNS?
add_althing_services_to_hosts_file(){
    for service in "${services[@]}"
    do
        if ! grep -q $service.$domain /etc/hosts; then
            echo "Adding $service.$domain to /etc/hosts."
            echo "127.0.0.1 ${service}.$domain" >> /etc/hosts
        fi
    done
}


add_CA_to_firefox(){
    # Install CA cert into firefox. Eventually, put into other browsers too. 
    # There is a powershell implementation of this on this page: https://stackoverflow.com/questions/1435000/programmatically-install-certificate-into-mozilla
    for certDB in $(find  /home/*/.mozilla* -name "cert8.db")
    do
      certDir=$(dirname ${certDB});
      echo "mozilla certificate" "install '${stackname}' in ${certDir}"
      # I found that most certutil instructions missed the importance of "sql:", probably because firefox was using the old version then. 
      # For more info, checkout: https://askubuntu.com/questions/244582/add-certificate-authorities-system-wide-on-firefox/792806#792806
      certutil -A -n "${stackname} Root CA" -t "TCu,Cuw,Tuw" -d sql:${certDir} -i ca.pem
    done
}

remove_temp_containers(){
    # Remove the temperary vault container.
    if [ $containerId ]; then
        docker stop $containerId
        docker rm $containerId
    fi
    if [ $containerId2 ]; then
        docker stop $containerId2
        docker rm $containerId2
    fi
    if [ $containerId3 ]; then
        docker stop $containerId3
        docker rm $containerId3
    fi

}

volume_exists(){
    if docker volume ls | grep -Fq ${stackname}_$1 ; then
        return 0
    else
        return 1
    fi
}

# Waits for the container to finish beinsg removed and then removes the volume.
remove_volume(){
    echo "Removing $1 volume"
    for second in `seq 1 15`; do
        docker volume rm $1
        if [ $? -eq 0 ] ; then
            break
        fi
        sleep 1
    done
}

# $1: The name of the volume to create.
create_volume(){
    if [ $reinstall -eq 1 ] ; then
        remove_volume ${stackname}_$1
    fi
    docker volume create ${stackname}_$1
}

# $1: The name of the secret.
# $2: The value of the secret.
create_secret(){
    # TODO: Only remove the secret if it exists.
    docker secret rm "${stackname}_$1"
    echo -e "$2" | docker secret create "${stackname}_$1" - 
}

# $1: The field to extract. 
# $2: The JSON string.
extract_from_json(){
    grep -Eo '"'$1'":.*?[^\\]"' <<< "$2" | cut -d \" -f 4
}