initialize_ha_db() {
    containerId3=$(docker run -d -e POSTGRES_DB=homeassistant -v ${stackname}_ha_db:/var/lib/postgresql/data althing/ha_db)
    # TODO: Have this detect when the DB has been initialized rather than a static wait.
    sleep 15
    docker cp ./ha_db/data/pg_hba.conf $containerId3:/var/lib/postgresql/data/pg_hba.conf
    docker cp ./ha_db/data/pg_ident.conf $containerId3:/var/lib/postgresql/data/pg_ident.conf
    docker cp ./ha_db/data/postgresql.conf $containerId3:/var/lib/postgresql/data/postgresql.conf
}