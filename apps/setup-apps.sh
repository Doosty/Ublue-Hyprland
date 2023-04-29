#!/bin/bash

source="."
dest="/"
# loop over sub-directories in source
find "$source" -mindepth 1 -maxdepth 1 -type d | while read subdir; do
    # copy dirs inside subdir
    echo "Copying $(basename $subdir) to $dest"
    for item in "$subdir"/*; do
        if [ -d "$item" ]; then
            cp -r "$item" "$dest/"
	    #echo "Copying $(readlink -f $item) to $dest/"
        fi
    done
    setupscript="$subdir/setupscript.sh"
    # if exists and is executable, run setup script
    if [ -f "$setupscript" ]; then
        if [ -x "$setupscript" ]; then
            echo "Running $setupscript"
            "$setupscript"
        else
            echo "Error: $setupscript is not executable."
        fi
    fi
done


