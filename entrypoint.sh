#!/.nix-profile/bin/bash -x

# Bring in Docker environment
SERVERS="[[{name,inet_localhost_1},{address,\"$BIND_ADDRESS\"},{port,$BIND_PORT},{family,inet},{processes,2}]]"

exec erldns "$@" -erldns servers "$SERVERS"
