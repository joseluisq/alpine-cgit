#!/bin/sh

set -e

# Check for incomming Nginx server commands or subcommands only
if [ "$1" = "nginx" ] || [ "${1#-}" != "$1" ]; then
    if [ "${1#-}" != "$1" ]; then
        set -- nginx "$@"
    fi

    chown nginx:nginx /var/cache/cgit
    chmod u+g /var/cache/cgit

    # Replace environment variables only if `USE_CUSTOM_CONFIG` is not defined or equal to `false`
    if [[ -z "$USE_CUSTOM_CONFIG" ]] || [[ "$USE_CUSTOM_CONFIG" = "false" ]]; then
        envsubst < /tmp/cgitrc.tmpl > /etc/cgitrc
    fi

    spawn-fcgi \
        -u nginx -g nginx \
        -s /var/run/fcgiwrap.sock \
        -n -- /usr/bin/fcgiwrap \
        & exec "$@"
else
    exec "$@"
fi
