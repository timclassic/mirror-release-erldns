FROM stoo/nixbase:stoo-0.1-1

RUN nix-env -f . -iA \
    erldns \
    && nix-collect-garbage -d
