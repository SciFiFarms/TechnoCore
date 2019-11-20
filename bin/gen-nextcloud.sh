#!/usr/bin/env bash
# TODO: Figure out how to auto include this.
source ${lib_path}create-secret.sh

echo -e "Reminder: In most terminals you have to use ctrl+shift+v to paste (alternatively, right click) and you won't see the result in the token field."
read -p "Nextcloud monitoring URL: " url
read -p "Nextcloud username: " username
read -s -p "Nextcloud password: " password
echo ""

create_secret nextcloud_exporter url "$url"
create_secret nextcloud_exporter username "$username"
create_secret nextcloud_exporter password "$password"
