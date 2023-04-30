#!/bin/bash

source="/tmp/myapps"
dest="/"

# loop over sub-directories in source
find "$source" -mindepth 1 -maxdepth 1 -type d | while read subdir; do
    # copy dirs inside subdir
    echo "Installing $(basename $subdir)"
    for item in "$subdir"/*; do
        if [ -d "$item" ]; then
            cp -r "$(readlink -f $item)" "$dest"
        fi
    done
    setupscript="$(readlink -f $subdir)/setupscript.sh"
    # if setupscript exists, make executable and run
    if [ -f "$setupscript" ]; then
        if [ ! -x "$setupscript" ]; then
            echo "Running scriptlet for $subdir"
	    chmod +x "$setupscript"
        fi
        "$setupscript"
    fi
done


