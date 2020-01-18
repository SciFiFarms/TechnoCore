add_CA_to_firefox(){
    # Install CA cert into firefox. Eventually, put into other browsers too. 
    # There is a powershell implementation of this on this page: https://stackoverflow.com/questions/1435000/programmatically-install-certificate-into-mozilla
    for certDB in $(find  /home/*/.mozilla* -name "cert8.db")
    do
      certDir=$(dirname ${certDB});
      echo "mozilla certificate" "install '${stack_name:-technocore}' in ${certDir}"
      # I found that most certutil instructions missed the importance of "sql:", probably because firefox was using the old version then. 
      # For more info, checkout: https://askubuntu.com/questions/244582/add-certificate-authorities-system-wide-on-firefox/792806#792806
      certutil -A -n "${stack_name:-technocore} Root CA" -t "TCu,Cuw,Tuw" -d sql:${certDir} -i ca.pem
    done
}

# $1: The field to extract. 
# $2: The JSON string.
# TODO: This is duplicated in portainer's dogfish instance. 
extract_from_json(){
    grep -Eo '"'$1'":.*?[^\\]"' <<< "$2" | cut -d \" -f 4
}
