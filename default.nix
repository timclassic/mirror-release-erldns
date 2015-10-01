{ path ? <nixpkgs>, gitRef, nixSha256 }:

with import path {}; rec {
  basename = "erldns";
  version = "0.1.0";

  release = stdenv.mkDerivation {
    name = "${basename}-${version}";
    src = fetchgit {
      url = ./.;
      rev = "${gitRef}";
      sha256 = "${nixSha256}";
    };

    buildInputs = [ git cacert otp rebar3 ];

    buildPhase = ''
      export SSL_CERT_FILE=${cacert}/etc/ca-bundle.crt
      export HOME=$NIX_BUILD_TOP
      rebar3 update
      rebar3 as nix tar
    '';

    installPhase = ''
      set -x
      mkdir $out
      tar -zx -C $out -f _build/nix/rel/${basename}/${basename}-*.tar.gz
      set +x
    '';
    
    # When used as `nix-shell --pure`
    shellHook = ''
      export SSL_CERT_FILE=${cacert}/etc/ca-bundle.crt
    '';
  };

  tgz = stdenv.mkDerivation {
    name = "${basename}-${version}.tar.gz";
    src = release;

    installPhase = ''
      tar -zc -C $src -f $out .
    '';
  };
}
