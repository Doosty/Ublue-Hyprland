#! /bin/sh

# use this var instead of . 
currentdir=$( dirname -- "$( readlink -f -- "$0"; )"; ) 

# copy subdirs to /
for item in "$currentdir"/*; do
    if [ -d "$item" ]; then
        cp -r "$(readlink -f $item)" "/"
    fi
done


chmod +x "/usr/bin/keyd"
chmod +x "/usr/bin/keyd-application-mapper"

# keyd setup
groupadd keyd
systemctl enable keyd.service
