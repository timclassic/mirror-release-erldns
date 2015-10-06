#!/.nix-profile/bin/bash -x

# Load zone file using curl, if specified
if [ -n "$ZONES_URL" ]; then
    curl "$ZONES_URL" >/var/erldns/config/zones.json
fi

# Bring in Docker environment
SERVERS="[[{name,inet_1},{address,\"$BIND_ADDRESS\"},{port,$BIND_PORT},{family,inet}]]"

exec privbind -u erldns erldns "$@" -erldns servers "$SERVERS"
