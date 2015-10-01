{ path ? <nixpkgs>, gitRef, nixSha256 }:

with import ./default.nix {
  path = path;
  gitRef = gitRef;
  nixSha256 = nixSha256;
};

{
  inherit release;
}
