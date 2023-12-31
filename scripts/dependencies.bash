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
SCRIPTPATH="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"
. "$SCRIPTPATH/utils.bash"

[ "$EUID" -ne 0 ] && echo "Please run as root." && exit 1

: "${GUI:=1}"
: "${MISC:=1}"

apt update

__msg_info "Installing general apts"
DEBIAN_FRONTEND=noninteractive apt install \
    git curl wget openssh-server \
    tmux vim ripgrep fzf \
    python3 python3-pip \
    flake8 yamllint jq python3-autopep8 clang-format \
    build-essential clang clangd bear gdb cmake exuberant-ctags \
    lightdm dwm stterm fonts-symbola \
    shellcheck \
    xclip \
    gocryptfs \
    nload tshark termshark nmap \
    -y || __error_exit $LINENO "Something wrong happened with installing apt dependencies."

([ "$GUI" == "1" ] && \
    __msg_info "Installing GUI related apts" && \
    DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-desktop gnome-terminal) ||
    __msg_info "Did not install GUI related dependencies."

__msg_info "Installing snaps"
command -v snap >/dev/null || __error_exit $LINENO "No snaps avaiable."
snap install lxd
snap install --beta prettier

__msg_info "Installing misc"
(
    [ "$MISC" == "1" ] && \
        DEBIAN_FRONTEND=noninteractive apt install -o Dpkg::Options::="--force-overwrite" bat -y && (ln -s /usr/bin/batcat /usr/bin/bat 2> /dev/null || true) && \
        VERSION=v4.2.0 BINARY=yq_linux_amd64; wget "https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz" -O - | tar xz && mv ${BINARY} /usr/bin/yq && \
        VERSION=v3.3.1 BINARY=linux_amd64;    wget "https://github.com/mvdan/sh/releases/download/${VERSION}/shfmt_${VERSION}_${BINARY}"  && mv shfmt_${VERSION}_${BINARY} /usr/bin/shfmt
) || __msg_info "Did not install misc related dependencies."
