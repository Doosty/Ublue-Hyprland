#! /bin/sh

pythoninstallscript="./app-dir/install.sh"
if [ ! -x "$pythoninstallscript" ]; then
    chmod +x "$pythoninstallscript"
fi
"$pythoninstallscript"

