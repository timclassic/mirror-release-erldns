set -euo pipefail

cmd=$1; shift

REF=$(git rev-parse HEAD)
SHA256=$(nix-prefetch-git file://$PWD --rev $REF | tail -n 1)
exec "$cmd" --argstr gitRef $REF --argstr nixSha256 $SHA256 "$@"
