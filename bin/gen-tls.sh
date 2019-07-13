#!/usr/bin/env bash
# TODO: Figure out how to auto include this.
source ${lib_path}acme-helpers.sh
source ${lib_path}create-secret.sh

# TODO: Consider having these optionally passed in via command line or ENV instead of forcing from CMD. 
#       It would allow me to not have to input the creds every time. Nice. GOOD FIRST TICKET
#       Should also investigate why if failed after running the first time, it has to be restarted to work. 
# https://stackoverflow.com/questions/3980668/how-to-get-a-password-from-a-shell-script-without-echoing
echo -e "\n\n\n"
echo -e "A DuckDNS domain and token is needed to setup LetsEncrypt (secures all communication)."
echo -e "LetsEncrypt is not required, but does produce the best results. Run the installer with the --dev flag to use a self signed cert."
echo -e "1) Visit https://www.duckdns.org/ and login using an account you already have (hopefully)."
echo -e "2) Create a duckdns sub-domain."
echo -e "3) Enter your sub-domain and token in the following prompts."
echo -e "   Example: If your domain is technocore.duckdns.org, you should enter \"technocore\" "
echo -e "   Reminder: In most terminals you have to use ctrl+shift+v to paste (alternatively, right click) and you won't see the result in the token field."
read -p "DuckDNS Sub-domain: " domain
read -s -p "DuckDNS Token: " token
echo ""

# acme_env file should contain ACME_FLAGS, all other vars are optional. 
# It should support any .env vars that acme.sh supports. 
# TODO: Turn into snippet
# https://stackoverflow.com/questions/23929235/multi-line-string-with-extra-space-preserved-indentation
acme_secret=$(cat <<-END
    ACME_FLAGS="--dns dns_duckdns"
    ACME_DOMAIN="${domain}.duckdns.org"
    DuckDNS_Token="$token"
END
)
if update_duckdns_tls "$acme_secret" issue 
then
    # TODO: Rather than creating separate secrets, it would be better to verify 
    # the current create_secret can't handle removal of secrets that exist in 
    # more than one service and then fix that if it is an issue
    create_secret home_assistant domain "$domain.duckdns.org"
    create_secret esphome domain "$domain.duckdns.org"
    create_secret grafana domain "$domain.duckdns.org"
    create_secret health domain "$domain.duckdns.org"
    # Update the portainer secret last. It will restart the container.
    create_secret portainer acme_env "$acme_secret"
else
    echo "Could not issue TLS cert."
    exit 1
fi
exit 0
