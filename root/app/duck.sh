#!/usr/bin/with-contenv bash
# shellcheck shell=bash

if [ "${LOG_FILE,,}" = "true" ]; then
    DUCK_LOG="/config/duck.log"
    touch "${DUCK_LOG}"
    touch /config/logrotate.status
    /usr/sbin/logrotate -s /config/logrotate.status /app/logrotate.conf
else
    DUCK_LOG="/dev/null"
fi

{
    # Use cloudflare to autodetect IP if UPDATE_IP is set
    if [ "${UPDATE_IP}" = "ipv4" ]; then
        echo "Detecting IPv4 via CloudFlare"
        IPV4=$(dig +short ch txt whoami.cloudflare -4 @1.1.1.1 | sed 's/"//g')
        RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=${IPV4}")
    elif [ "${UPDATE_IP}" = "ipv6" ]; then
        echo "Detecting IPv6 via CloudFlare"
        IPV6=$(dig +short ch txt whoami.cloudflare -6 @2606:4700:4700::1111 | sed 's/"//g')
        RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ipv6=${IPV6}")
    elif [ "${UPDATE_IP}" = "both" ]; then
        echo "Detecting IPv4 and IPv6 via CloudFlare"
        IPV4=$(dig +short ch txt whoami.cloudflare -4 @1.1.1.1 | sed 's/"//g')
        IPV6=$(dig +short ch txt whoami.cloudflare -6 @2606:4700:4700::1111 | sed 's/"//g')
        RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=${IPV4}&ipv6=${IPV6}")
    else
    # Use DuckDns to autodetect IPv4 (default behaviour)
        echo "Detecting IPv4 via DuckDNS"
        DRESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=&verbose")
        STATE=$(${DRESPONSE} | awk 'NR==4')
        IPV4=$(${DRESPONSE} | awk 'NR==2')
        IPV6=$(${DRESPONSE} | awk 'NR==3')
        if [ "${STATE}" = "UPDATED" ] || [ "${STATE}" = "NOCHANGE" ]; then
            RESPONSE="OK"
            else
            RESPONSE="KO"
        fi
    fi

    if [ "${RESPONSE}" = "OK" ]; then
        if [ "${UPDATE_IP}" = "ipv4" ]; then
            echo "Your IP was updated at $(date) to IPv4: ${IPV4}"
        elif [ "${UPDATE_IP}" = "ipv6" ]; then
            echo "Your IP was updated at $(date) to IPv6: ${IPV6}"
        else
            echo "Your IP was updated at $(date) to IPv4: ${IPV4} & IPv6 (if available): {$IPV6}" 
        fi
    else
        echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
    fi
} | tee -a "${DUCK_LOG}"
