FROM alpine:3.10
COPY --from=docker:18.09 / /
COPY --from=docker/compose:1.24.1 / /

RUN apk add --no-cache bash grep curl coreutils openssl mosquitto-clients 
RUN curl -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 --output /usr/local/bin/yq && \
    chmod -R o+xr /usr/local/bin
COPY bin/ /usr/local/bin
COPY sidecars/ /usr/local/bin/sidecars
COPY lib/ /usr/local/lib/technocore
COPY services/ /var/lib/technocore

#ENTRYPOINT ["go-init"]
#CMD ["/usr/local/bin/sidecars/create-secret.sub"]

WORKDIR /var/lib/technocore
