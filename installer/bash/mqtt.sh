mqtt_i() {
    docker exec -i $containerId2 "$@"
}

initialize_mqtt() {
    echo "Initializing MQTT"
    # I have to pass in a custom config to start vault without TLS.
    containerId2=$(docker run -d -p 15672:15672 --network ${stackname} --name mqtt --hostname mqtt -v ${stackname}_mqtt:/var/lib/rabbitmq rabbitmq:3.7.4-management)
    sleep 15

    local response=$(vault_i write -force -format=json /sys/tools/random/32)
    local password=$(extract_from_json random_bytes "$response")
    mqtt_i rabbitmqctl add_user vault $password
    mqtt_i rabbitmqctl set_user_tags vault administrator
    mqtt_i rabbitmqctl set_permissions vault ".*" ".*" ".*"
    create_secret mqtt_vault_username vault
    create_secret mqtt_vault_password $password

    vault_i secrets enable rabbitmq
    vault_i write rabbitmq/config/connection \
        connection_uri="http://mqtt:15672" \
        username="vault" \
        password="$password"
}