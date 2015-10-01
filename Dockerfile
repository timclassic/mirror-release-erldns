FROM stoo/nixbase:stoo-0.1-1

ADD . /app/src
WORKDIR /app/src
RUN bash ./nixlocal.sh nix-env -f . -iA \
    tgz \
    && nix-collect-garbage -d
WORKDIR /app
RUN rm -rf src
