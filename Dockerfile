FROM alpine:3.10
ARG DEFAULT_DEPLOY_STACK=technocore

COPY --from=docker:18.09 / /
COPY --from=docker/compose:1.24.1 / /

RUN apk add --no-cache bash grep curl coreutils openssl mosquitto-clients git
RUN curl -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 --output /usr/local/bin/yq && \
    chmod -R o+xr /usr/local/bin

WORKDIR /var/lib/technocore
COPY ${DEFAULT_DEPLOY_STACK}.stack.sh /var/lib/technocore/stack.sh
RUN ln -s /mnt/technocore/.env /var/lib/technocore/.env
RUN /var/lib/technocore/stack.sh

COPY bin/ /usr/local/bin
COPY sidecars/ /usr/local/bin/sidecars
COPY lib/ /usr/local/lib/technocore
#COPY services/ /var/lib/technocore

#ENTRYPOINT ["go-init"]
#CMD ["/usr/local/bin/sidecars/create-secret.sub"]

