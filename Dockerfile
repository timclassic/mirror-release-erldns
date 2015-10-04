FROM stoo/nixbase:stoo-0.1-1

# Build and install
WORKDIR /src
COPY . /src/
RUN bash nixgit.sh nix-env -f . -iA \
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
        /var/erldns/config/zones.json

# Clean up after build
WORKDIR /
RUN rm -rf /src

ENTRYPOINT ["erldns"]
CMD ["console"]
ENV RUNNER_LOG_DIR=/var/erldns/log

# Add erldns user and change ownership of directories where erldns
# user needs write access
RUN useradd -c "Erldns User" -d /app -m erldns
RUN chown erldns:erldns \
        /var/erldns/mnesia \
        /var/erldns/log \
        /var/erldns/sasl
USER erldns
WORKDIR /var/erldns

EXPOSE 4369 8053 8082
VOLUME /var/erldns/config \
       /var/erldns/mnesia \
       /var/erldns/log \
       /var/erldns/sasl
