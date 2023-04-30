#!/bin/bash

#copy subdirs to /
for item in "."/*; do
    if [ -d "$item" ]; then
        cp -r "$(readlink -f $item)" "/"
    fi
done

#systemctl disable display-manager.service  #only needed if we already have a DM
echo "Lemurs setup: enabling lemurs.service"
systemctl enable lemurs.service

