set -euo pipefail

cmd=$1; shift

ref=$(git rev-parse HEAD)
sha256=$(nix-prefetch-git file://$PWD --rev $ref | tail -n 1)
exec "$cmd" --argstr gitRef $ref --argstr nixSha256 $sha256 "$@"
