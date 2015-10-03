{ path ? <nixpkgs>, gitRef, nixSha256 }:

with import path {}; rec {
  basename = "erldns";
  version = "0.1.0";

  erldns = stdenv.mkDerivation {
    inherit gnugrep;
    inherit gawk;
    inherit which;
    inherit otp;
    inherit nettools;
    inherit eject;         # This is util-linux (contains `logger')

    name = "${basename}-${version}";
    src = fetchgit {
      url = ./.;
      rev = "${gitRef}";
      sha256 = "${nixSha256}";
    };

    buildInputs = [ git cacert otp rebar3 makeWrapper ];

    buildPhase = ''
      export SSL_CERT_FILE=${cacert}/etc/ca-bundle.crt
      export HOME=$NIX_BUILD_TOP
      rebar3 update
      rebar3 as nix tar
    '';

    installPhase = ''
      libdir="lib/${basename}"
      fulldir="$out/$libdir"
      mkdir -p "$fulldir"
      tar -zx -C "$fulldir" \
        -f _build/nix/rel/${basename}/${basename}-${version}.tar.gz
      mkdir $out/bin
      for link in ${basename} ${basename}-${version}; do
        ln -s "../$libdir/bin/$link" "$out/bin/$link"
      done
    '';

    postFixup = ''
      libdir="lib/${basename}"
      fulldir="$out/$libdir"
      wrapProgram "$fulldir/bin/${basename}" --prefix PATH ":" \
        "${gnugrep}/bin:${gawk}/bin:${which}/bin:${otp}/bin:${nettools}/bin:${eject}/bin"
      wrapProgram "$fulldir/bin/${basename}-${version}" --prefix PATH ":" \
        "${gnugrep}/bin:${gawk}/bin:${which}/bin:${otp}/bin:${nettools}/bin:${eject}/bin"
    '';

    # When used as `nix-shell --pure'
    shellHook = ''
      export SSL_CERT_FILE=${cacert}/etc/ca-bundle.crt
    '';
  };
}
