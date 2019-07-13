#!/usr/bin/env bash

lib_path=/usr/share/mqtt-scripts/

for file in ${lib_path}*.sub; do
    # TODO: Make this ignore .pub files? Or maybe I just use *.sub.
    if [ "$file" == "/usr/share/mqtt-scripts/init.sh" ] ; then
        continue;
    fi
    source $file &
done