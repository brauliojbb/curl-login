#!/bin/bash

# Created by: Braulio José Batista Braga - 06/05/2020
# Example script used to log in via cURL and capture information from a site

set -e

IP_DNS="192.168.20.7"
USER="administrator"
PASSWORD="XXXXXXXX"
HOST='https://'$IP_DNS'/ntp/status_ntp.php'
GREP='Synced '

function get_cookie() {
	curl -k -silent --output /dev/null --cookie-jar - 'https://'$IP_DNS'/login/controller_activation.php' -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: */*' -H 'Accept-Language: pt-BR,pt;q=0.8,en-US;q=0.5,en;q=03' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'X-Requested-With: XMLHttpRequest' -H 'Origin: https://'$IP_DNS'' -H 'Connection: keep-alive' -H 'Referer: https://'$IP_DNS'/login/login.php' --data 'authenticate=true&password='$PASSWORD'&user='$USER'' | grep HttpOnly | awk '{print$7}'
}

function ntp_service_status() {
	curl -ks $HOST -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Connection: keep-alive' -H 'Referer: https://'$IP_DNS'/index.php' -H 'Cookie: PHPSESSID='$(get_cookie)'; fechar=1' -H 'Upgrade-Insecure-Requests: 1' | grep $GREP | awk -F"b>|<" '{print$3}'
}

        if [ "$(ntp_service_status)" == "$GREP" ]
        then
            echo 0
            #echo "OK: NTP Service Status: "$(ntp_service_status)""
	    exit 1
        else
            echo 1
            #echo "FAIL: NTP Service Status: "$(ntp_service_status)""
            exit 1
        fi


# End of the Example
