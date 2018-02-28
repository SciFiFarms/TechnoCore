FROM ssl
RUN /usr/local/bin/generate-certs

FROM homeassistant/home-assistant
ARG userid
ARG username
#RUN useradd --no-create-home --user-group --shell /bin/bash --home-dir $APP_HOME --uid $userid $username
RUN useradd --no-create-home --user-group --shell /bin/bash --uid $userid $username 
COPY --from=0 /certs/cert.pem /certs/
COPY --from=0 /certs/key.csr /certs/
COPY --from=0 /certs/key.pem /certs/
COPY --from=0 /certs/openssl.cnf /certs/