FROM stoo/nixbase:stoo-0.1-1

# Build and install
WORKDIR /src
COPY . /src/
RUN nix-env -f '<nixpkgs>' -iA \
        privbind \
        curl \
    && bash nixgit.sh nix-env -f . -iA \
        erldns \
    && nix-collect-garbage -d

# Create directories and include example configuration
RUN mkdir -p /var/erldns/config \
             /var/erldns/mnesia \
             /var/erldns/log \
             /var/erldns/sasl \
    && install -m 0644 \
        $(find \
            $(bash nixgit.sh nix-build . -A erldns 2>/dev/null) \
            -name example.zone.json) \
        /var/erldns/config/zones.json \
    && install -m 0755 /src/entrypoint.sh /var/erldns/entrypoint.sh

# Clean up after build
WORKDIR /
RUN rm -rf /src

# Runtime environment
ENV RUNNER_LOG_DIR=/var/erldns/log \
    BIND_ADDRESS=0.0.0.0 \
    BIND_PORT=53
ENTRYPOINT ["/var/erldns/entrypoint.sh"]
CMD ["console"]

# Add erldns user and change ownership of directories where erldns
# user needs write access
RUN useradd -c "Erldns User" -d /app -m erldns
RUN chown erldns:erldns \
        /var/erldns/mnesia \
        /var/erldns/log \
        /var/erldns/sasl
WORKDIR /var/erldns

EXPOSE 53 4369 8082 8083
VOLUME /var/erldns/config \
       /var/erldns/mnesia \
       /var/erldns/log \
       /var/erldns/sasl
