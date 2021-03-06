#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
. "$DIR/base.sh"
. "$DIR/ansi"

if [[ "$DISTRIB_ID" != "Debian" ]]; then
    ansi --yellow "Distribution is not Debian"
    exit 1

fi

if [[ "$DISTRIB_RELEASE" != "11" ]]; then
    ansi --yellow "Debian is not version 11"
    exit 1
fi

# ask sudo upfront
sudo -v

is_using_systemd=false
pidof systemd && is_using_systemd=true

if [ "$is_using_systemd" == true ]; then
    sudo loginctl enable-linger "$USER"
fi

# ansi --green "Updating pacman.conf.."
# sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf
# sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf
# sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf
# sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf

# ansi --green "Enable timedatectl and set up timezone"
# sudo timedatectl set-timezone America/Sao_Paulo
# sudo timedatectl set-ntp 1
# sudo timedatectl set-local-rtc 0
# sudo ln -sf /usr/share/zoneinfo/Ameriaca/Sao_Paulo /etc/localtime

# ansi --green "Setup locale"
# sudo sed -i '/en_US.UTF-8$/s/^#//g' /etc/pacman.conf
# sudo locale-gen

ansi --green "Setup sysctl"

# $1 line $2 file
function sudo_add_line_if_not_in_file() {
    grep -qxF -- "$1" "$2" || echo "$1" | sudo tee -a "$2"
}

sudo_add_line_if_not_in_file "net.ipv4.ip_unprivileged_port_start=0" /etc/sysctl.conf
sudo_add_line_if_not_in_file "net.ipv4.ip_forward=1" /etc/sysctl.conf
