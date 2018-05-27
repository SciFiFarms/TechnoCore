#!/bin/bash

set -eu
set -o pipefail

# Updating DokuWiki may need to change files in directories which we hold in
# volumes, e.g. `data` or `conf`. Therefore, we need to make sure these files
# are there when the container is started, not only when it is created. We do
# this by keeping track which version we last installed and update as necessary,
# or fully populate these folders if this is the first run.

dokudir=/dokuwiki
tmpdir=/tmp/dokuwiki
verfile=.last-version
containerver="$(date -f <(echo "$DOKUWIKI_VERSION" | tr -d '[:alpha:]') +%s)"

if [ ! -d "$dokudir" ]; then
    echo "DokuWiki does not appear to be installed correctly at: $dokudir." >&2
    exit 1
fi

# Check for downgrade/overwrite parameters
if [ "$1" = 'downgrade' ]; then downgrade=1; else downgrade=0; fi
if [ "$1" = 'overwrite' ]; then overwrite=1; else overwrite=0; fi

if [ "$1" = 'run' ] || [ "$1" = 'downgrade' ] || [ "$1" = 'overwrite' ]; then
    # Check each volume directory in turn
    for d in conf data lib/plugins lib/tpl; do
        if [ -f "$dokudir/$d/$verfile" ]; then
            volumever="$(date -f <(awk '{print $1}' "$dokudir/$d/$verfile" | tr -d '[:alpha:]') +%s)"
        else
            volumever=0
        fi

        if [ "$volumever" -eq "$containerver" ] && [ ! "$overwrite" -eq 1 ]; then
            # Do nothing for equal versions
            continue
        elif [ "$volumever" -lt "$containerver" ] || [ "$downgrade" -eq 1 ] || [ "$overwrite" -eq 1 ]; then
            # First, unpack a temporary copy of the current DokuWiki version
            if [ ! -d "$tmpdir" ]; then
                mkdir "$tmpdir"
                tar -zxf /dokuwiki.tgz -C "$tmpdir" --strip-components 1
            fi

            # Then, update if the container version is newer than the volume version
            # Or if overridden using `downgrade`
            echo "Migrating $d..."
            cp -r "$tmpdir/$d/"* "$dokudir/$d/"
            cp "$tmpdir/VERSION" "$dokudir/$d/$verfile"
        elif [ "$volumever" -gt "$containerver" ]; then
            # Otherwise print an error message and stop
            cat >&2 <<EOM
This volume has perviously been used with a newer version of DokuWiki.
If you want to force a downgrade (at your own risk!), run the \`downgrade\` command:
    docker run ... mprasil/dokuwiki donwgrade
EOM
        exit 2
        fi
    done

    # Clean up any temporary files
    rm -rf "$tmpdir"

    # TODO: Move this to a repo dedicated to the wiki image. 
    # Needed some additional work in order to have correct permissions set on host. 
    # It may be worth changing the group id too? 
    usermod --non-unique --uid $WWW_DATA_UID www-data
    if [ ! -d /var/log/lighttp ]; then
        install -d -o www-data -g $WWW_DATA_UID -m 777 /var/log/lighttpd
    fi
    chown -R www-data /var/log/
    chmod -R o+rw /var/log/
    chown -R www-data /var/run/lighttpd


    # Ensure persmissions are set correctly
    chown -R www-data:www-data "$dokudir"

    # Run the web server
    exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
else
    # Handle custom commands otherwise
    exec "$@"
fi