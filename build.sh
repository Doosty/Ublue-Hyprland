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

#WAYLAND ENV VARS
printf 'export SDL_VIDEODRIVER=wayland\n' | tee -a /etc/profile
printf 'export _JAVA_AWT_WM_NONREPARENTING=1\n' | tee -a /etc/profile
printf 'export QT_QPA_PLATFORM=wayland\n' | tee -a /etc/profile
printf 'export XDG_CURRENT_DESKTOP=sway\n' | tee -a /etc/profile
printf 'export XDG_SESSION_DESKTOP=sway\n' | tee -a /etc/profile
printf 'export GDK_BACKEND="wayland,x11"\n' | tee -a /etc/profile
printf 'export MOZ_ENABLE_WAYLAND=1\n' | tee -a /etc/profile
printf 'export QT_QPA_PLATFORMTHEME=qt5ct\n' | tee -a /etc/profile
