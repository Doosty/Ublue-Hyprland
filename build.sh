#!/bin/bash

# remove the default firefox (from fedora) in favor of the flatpak
rpm-ostree override remove firefox firefox-langpacks

echo "-- Installing RPMs defined in recipe.yml --"
rpm_packages=$(yq '.rpms[]' < /tmp/ublue-recipe.yml)
for pkg in $(echo -e "$rpm_packages"); do \
    echo "Installing: ${pkg}" && \
    rpm-ostree install $pkg; \
done
echo "---"

# install yafti to install flatpaks on first boot, https://github.com/ublue-os/yafti
pip install --prefix=/usr yafti
# add a package group for yafti using the packages defined in recipe.yml
yq -i '.screens.applications.values.groups.Custom.description = "Flatpaks defined by the image maintainer"' /etc/yafti.yml
yq -i '.screens.applications.values.groups.Custom.default = true' /etc/yafti.yml
flatpaks=$(yq '.flatpaks[]' < /tmp/ublue-recipe.yml)
for pkg in $(echo -e "$flatpaks"); do \
    yq -i ".screens.applications.values.groups.Custom.packages += [{\"$pkg\": \"$pkg\"}]" /etc/yafti.yml
done


# install apps from local dir
source="/tmp/myapps"
customscriptname="setupscript.sh"
# loop over sub-directories in source
find "$source" -mindepth 1 -maxdepth 1 -type d | while read subdir; do
    echo "Installing $subdir ..."
    subdirpath="$(readlink -f $subdir)"
    scriptpath="$subdirpath/$customscriptname"
    # if setupscript exists, make executable and run
    if [ -f "$scriptpath" ]; then
        if [ ! -x "$scriptpath" ]; then
            chmod +x "$scriptpath"
        fi
        "$scriptpath"
    # if no script just copy contents to /
    else
        cp -r "$subdirpath/*" "/"
    fi
done

