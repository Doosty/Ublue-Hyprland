#!/usr/bin/env bash
currentdir=$( dirname -- "$( readlink -f -- "$0"; )"; )

python3 "$currentdir"/setup.py install --optimize=1
cp "$currentdir"/nwg-displays.svg /usr/share/pixmaps/
cp "$currentdir"/nwg-displays.desktop /usr/share/applications/
