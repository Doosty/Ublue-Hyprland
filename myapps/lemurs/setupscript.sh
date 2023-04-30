#!/bin/bash

#copy subdirs to /
for item in "."/*; do
    if [ -d "$item" ]; then
        cp -r "$(readlink -f $item)" "/"
    fi
done

#sudo systemctl disable display-manager.service  #only needed if we already have a DM
echo "Lemurs setup: enabling lemurs.service"
sudo systemctl enable lemurs.service

