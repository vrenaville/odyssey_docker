#!/bin/sh

ODYSSEY_CONF=${CUSTOM_ODYSSEY_CONF:-$1}

exec /usr/local/bin/odyssey ${ODYSSEY_CONF} && tail -f /var/log/odyssey.log


