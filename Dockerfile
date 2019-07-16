FROM alpine:3.10
COPY --from=docker:18.09 / /
COPY --from=docker/compose:1.24.1 / /

RUN apk add --no-cache bash gawk sed grep bc coreutils openssl
COPY bin/ /usr/local/bin
COPY lib/ /usr/local/lib/technocore
COPY services/ /var/lib/technocore

#ENTRYPOINT ["go-init"]
CMD ["entrypoint.sh"]

WORKDIR /var/lib/technocore

