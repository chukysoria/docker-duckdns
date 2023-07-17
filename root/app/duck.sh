#!/usr/bin/with-contenv bash
# shellcheck shell=bash

if [ "${LOG_FILE}" = "true" ]; then
    DUCK_LOG="/config/duck.log"
    touch "${DUCK_LOG}"
    touch /config/logrotate.status
    /usr/sbin/logrotate -s /config/logrotate.status /app/logrotate.conf
else
    DUCK_LOG="/dev/null"
fi

{
    if [ "${FORCE_IPV6}" = "true" ]; then
        IPV6=$(curl -sS6 "https://ipconfig.io")
        RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=${IPV6}")
    else
        RESPONSE=$(curl -sS --max-time 60 "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=")
    fi

    if [ "${RESPONSE}" = "OK" ]; then
        echo "Your IP was updated at $(date)"
    else
        echo -e "Something went wrong, please check your settings $(date)\nThe response returned was:\n${RESPONSE}"
    fi
} | tee -a "${DUCK_LOG}"
