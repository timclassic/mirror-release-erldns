#!/.nix-profile/bin/bash -x

# Bring in Docker environment
SERVERS="[[{name,inet_1},{address,\"$BIND_ADDRESS\"},{port,$BIND_PORT},{family,inet}]]"

exec privbind -u erldns erldns "$@" -erldns servers "$SERVERS"
