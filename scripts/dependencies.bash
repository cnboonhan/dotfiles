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

: "${HEADLESS:=1}"

apt update 

__msg_info "Installing general apts"
DEBIAN_FRONTEND=noninteractive apt install \
    git curl wget openssh-server \
    tmux vim ripgrep fzf \
    python3 python3-pip \
    flake8 yamllint jq python3-autopep8 clang-format \
    build-essential clang bear gdb cmake exuberant-ctags \
    lightdm dwm stterm \
    shellcheck \
    xclip \
    nload tshark termshark nmap \
    -y  || __error_exit $LINENO "Something wrong happened with installing apt dependencies."

__msg_info "Installing GUI related apts"
( [ "$HEADLESS" == "0" ] && DEBIAN_FRONTEND=noninteractive apt install ubuntu-desktop gnome-panel gnome-settings-daemon xfce4 nautilus gnome-terminal ) \
    || __msg_info "Did not install GUI related dependencies. set HEADLESS=0 to install GUI dependencies."

__msg_info "Installing snaps"
command -v || __error_exit $LINENO "No snaps avaiable."
snap install lxd
snap install --beta prettier
snap install shfmt
