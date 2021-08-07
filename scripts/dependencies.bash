#!/usr/bin/env bash
# shellcheck source=/home/ubuntu/.bashrc

# exit codes:
#   0: success
#   1: general error exit
#   2: lockfile present

set -o errexit
set -o nounset
set -o pipefail

export PROJECT=dependencies-setup
. ./utils.bash

[ "$EUID" -ne 0 ] && echo "Please run as root." && exit 1

apt update 

DEBIAN_FRONTEND=noninteractive apt install \
    git curl wget openssh-server \
    tmux vim ripgrep fzf \
    python3 python3-pip \
    flake8 yamllint jq python3-autopep8 clang-format \
    build-essential clang bear gdb cmake exuberant-ctags \
    lightdm dwm stterm \
    xclip \
    nload tshark termshark nmap \
    -y  || __error_exit $LINENO "Something wrong happened with installing apt dependencies."

DEBIAN_FRONTEND=noninteractive apt install \
    ubuntu-desktop gnome-panel gnome-settings-daemon xfce4 nautilus gnome-terminal || __error_exit $LINENO "Something happened with installing apt dependencies for GUI"


__msg_info "Updating Ubuntu alternatives."
update-alternatives --set x-window-manager /usr/bin/dwm
update-alternatives --set x-session-manager /usr/bin/xfce4-session
update-alternatives --set x-terminal-emulator /usr/bin/st

__msg_info "Installing snaps"
command -v || { echo -e "No snap installs available" && exit 1; }
snap install lxd
snap install --beta prettier
snap install shfmt
