#!/bin/bash

source="."
dest="/"
# loop over sub-directories in source
find "$source" -mindepth 1 -maxdepth 1 -type d | while read subdir; do
    # copy dirs inside subdir
    echo "Copying $(basename $subdir) to $dest"
    for item in "$subdir"/*; do
        if [ -d "$item" ]; then
            cp -r "$(readlink -f $item)" "$dest"
	    echo "Copying $(readlink -f $item) to $dest"
        fi
    done
    setupscript="$(readlink -f $subdir)/setupscript.sh"
    # if setupscript exists, make executable and run
    if [ -f "$setupscript" ]; then
        if [ ! -x "$setupscript" ]; then
	    chmod +x "$setupscript"
        fi
        echo "Running $setupscript"
        "$setupscript"
    fi
done


