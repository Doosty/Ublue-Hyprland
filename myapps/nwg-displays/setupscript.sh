#! /bin/sh
currentdir=$( dirname -- "$( readlink -f -- "$0"; )"; )

pythoninstallscript="$currentdir/app-dir/install.sh"
if [ ! -x "$pythoninstallscript" ]; then
    chmod +x "$pythoninstallscript"
fi
"$pythoninstallscript"

