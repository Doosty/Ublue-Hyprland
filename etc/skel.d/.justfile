default:
  @just --list

boot-bios:
  systemctl reboot --firmware-setup

show-changelogs:
  rpm-ostree db diff --changelogs

create-distrobox-fedora38:
  echo 'Creating Fedora38 distrobox ...'
  distrobox create --image registry.fedoraproject.org/fedora-toolbox:38 -n fedora38-distrobox -Y

create-distrobox-boxkit:
  echo 'Creating Boxkit distrobox ...'
  distrobox create --image ghcr.io/ublue-os/boxkit -n boxkit -Y

create-distrobox-debian:
  echo 'Creating Debian distrobox ...'
  distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

create-distrobox-opensuse:
  echo 'Creating openSUSE distrobox ...'
  distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y
 
create-distrobox-ubuntu:
  echo 'Creating Ubuntu distrobox ...'
  distrobox create --image quay.io/toolbx-images/ubuntu-toolbox:22.04 -n ubuntu -Y

setup-flatpaks-mandatory:
  #!/bin/bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpaks=$(yq '.flatpaks[]' < /etc/ublue-recipe.yml)
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

setup-flatpaks-gaming:
  echo 'Setting up gaming experience ... lock and load.'
  flatpak install -y --user \\
  org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \\
  org.freedesktop.Platform.VulkanLayer.vkBasalt//22.08 \\
  com.github.Matoking.protontricks \\
  com.heroicgameslauncher.hgl \\
  com.usebottles.bottles \\
  com.valvesoftware.Steam \\
  com.valvesoftware.Steam.Utility.gamescope \\
  com.valvesoftware.Steam.CompatibilityTool.Boxtron \\
  com.valvesoftware.Steam.CompatibilityTool.Proton \\
  com.valvesoftware.Steam.CompatibilityTool.Proton-Exp \\
  com.valvesoftware.Steam.CompatibilityTool.Proton-GE \\
  net.davidotek.pupgui2
  flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications 
  flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam 
  flatpak override --user --env=MANGOHUD=1 com.heroicgameslauncher.hgl 
 
update-everything:
  rpm-ostree update
  flatpak update -y
  distrobox upgrade -a
  
setup-nix:
  echo 'Installing nix...'
  /usr/bin/nix-installer

enable-flatpak-theming:
  flatpak override --filesystem=$HOME/.themes
  flatpak override --filesystem=$HOME/.icons
#  flatpak override --env=XCURSOR_SIZE=32

