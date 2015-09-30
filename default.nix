{ path ? <nixpkgs>, gitRef, nixSha256 }:

with import path {}; {
  erldns = stdenv.mkDerivation {
    name = "erldns";
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
      mkdir $out
      tar -zx -C $out -f _build/nix/rel/$name/$name-*.tar.gz
    '';
    
    # When used as `nix-shell --pure`
    shellHook = ''
      unset http_proxy
      export SSL_CERT_FILE=${cacert}/etc/ca-bundle.crt
    '';
    # used when building environments
    extraCmds = ''
      unset http_proxy # otherwise downloads will fail ("nodtd.invalid")
      export SSL_CERT_FILE=${cacert}/etc/ca-bundle.crt
    '';
  };
}
