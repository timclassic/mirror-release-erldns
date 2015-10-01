FROM stoo/nixbase:stoo-0.1-1

# XXX: For dev purposes, remove when done
RUN nix-env -f '<nixpkgs>' -iA \
    rebar3 \
    makeWrapper \
    stdenv \
    otp

WORKDIR /src
COPY . /src/
RUN bash nixgit.sh nix-env -f . -iA \
    erldns \
    && nix-collect-garbage -d
WORKDIR /
RUN rm -rf /src

ENTRYPOINT ["erldns"]
CMD ["console"]

RUN useradd -c "Erldns User" -d /app -m erldns
USER erldns
WORKDIR /app
