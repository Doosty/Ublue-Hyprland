default:
  @just --list

bios:
  systemctl reboot --firmware-setup

changelogs:
  rpm-ostree db diff --changelogs

distrobox-boxkit:
  echo 'Creating Boxkit distrobox ...'
  distrobox create --image ghcr.io/ublue-os/boxkit -n boxkit -Y

distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y
 
distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

setup-flatpaks:
  #!/bin/bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpaks=$(yq '.flatpaks[]' < /etc/ublue-recipe.yml)
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

setup-pwa:
  echo 'Giving browser permission to create PWAs (Progressive Web Apps)'
  # Add for your favorite chromium-based browser
  flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.microsoft.Edge

setup-gaming:
  echo 'Setting up gaming experience ... lock and load.'
  flatpak install -y --user \\
  com.discordapp.Discord \\
  com.feaneron.Boatswain \\
  org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \\
  org.freedesktop.Platform.VulkanLayer.OBSVkCapture//22.08 \\
  org.freedesktop.Platform.VulkanLayer.vkBasalt//22.08 \\
  com.heroicgameslauncher.hgl \\
  com.obsproject.Studio \\
  com.obsproject.Studio.Plugin.OBSVkCapture \\
  com.obsproject.Studio.Plugin.Gstreamer \\
  com.usebottles.bottles \\
  com.valvesoftware.Steam \\
  com.valvesoftware.Steam.Utility.gamescope \\
  net.davidotek.pupgui2
  flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications 
  flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam 
  flatpak override --user --env=MANGOHUD=1 com.heroicgameslauncher.hgl 
 
update:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a
  
setup-nix:
  echo 'Installing nix...'
  /usr/bin/nix-installer

flatpak-theming:
  flatpak override --filesystem=$HOME/.themes
  flatpak override --filesystem=$HOME/.icons
  flatpak override --env=GTK_THEME=Dracula 
  flatpak override --env=ICON_THEME=Dracula 
  flatpak override --env=XCURSOR_SIZE=32
  flatpak override --env=XCURSOR_THEME=phinger-cursors-light

