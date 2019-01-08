add_CA_to_firefox(){
    # Install CA cert into firefox. Eventually, put into other browsers too. 
    # There is a powershell implementation of this on this page: https://stackoverflow.com/questions/1435000/programmatically-install-certificate-into-mozilla
    for certDB in $(find  /home/*/.mozilla* -name "cert8.db")
    do
      certDir=$(dirname ${certDB});
      echo "mozilla certificate" "install '${stack_name}' in ${certDir}"
      # I found that most certutil instructions missed the importance of "sql:", probably because firefox was using the old version then. 
      # For more info, checkout: https://askubuntu.com/questions/244582/add-certificate-authorities-system-wide-on-firefox/792806#792806
      certutil -A -n "${stack_name} Root CA" -t "TCu,Cuw,Tuw" -d sql:${certDir} -i ca.pem
    done
}

# Remove the temporary vault container.
remove_temp_containers(){
    if [ $containerId ]; then
        docker stop $containerId > /dev/null
        docker rm $containerId > /dev/null
    fi
}

# $1: The name of the volume to create.
create_volume(){
    echo "Creating volume $(docker volume create ${stack_name}_$1)"
}

# $1: The name of the secret.
# $2: The value of the secret.
# TODO: This is duplicated in portainer's dogfish instance. 
create_secret(){
    echo "Creating secret ${stack_name}_$1"
    echo -e "$2" | docker secret create "${stack_name}_$1" - > /dev/null
}

# $1: The field to extract. 
# $2: The JSON string.
# TODO: This is duplicated in portainer's dogfish instance. 
extract_from_json(){
    grep -Eo '"'$1'":.*?[^\\]"' <<< "$2" | cut -d \" -f 4
}

# $1: The username to create
# This is tightly coupled with the migrations in the portainer image. If you 
# want to create more mqtt users, add them as migrations in the portainer image. 
create_mqtt_user(){
    local response
    echo "Creating MQTT user $1"
    until response=$(vault_i write -force -format=json /sys/tools/random/32)
    do
        echo "Couldn't reach Vault. Will retry after sleep."
        sleep 5
    done
    local password=$(extract_from_json random_bytes "$response")

    create_secret ${1}_mqtt_username $1
    create_secret ${1}_mqtt_password $password
}