FROM postgres
#RUN createuser homeassistant
#ENV POSTGRES_INITDB_ARGS=--auth-host=cert
#COPY pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
ARG userid
ARG username
#RUN useradd --no-create-home --user-group --shell /bin/bash --uid $userid $username 
RUN usermod -u $userid postgres
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d

#VOLUME /certs

# Taken from: https://stackoverflow.com/questions/30848670/how-to-customize-the-configuration-file-of-the-official-postgresql-docker-image
#COPY postgresql.conf      /tmp/postgresql.conf
#COPY updateConfig.sh      /docker-entrypoint-initdb.d/_updateConfig.sh

#_updateConfig.sh
#!/usr/bin/env bash
#cat /tmp/postgresql.conf > /var/lib/postgresql/data/postgresql.conf
 