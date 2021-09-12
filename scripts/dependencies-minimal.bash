#!/usr/bin/env bash
# shellcheck source=/home/ubuntu/.bashrc

# exit codes:
#   0: success
#   1: general error exit
#   2: lockfile present

set -o errexit
set -o nounset
set -o pipefail

export PROJECT=dependencies-setup-minimal
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
    shellcheck \
    xclip \
    gocryptfs \
    -y || __error_exit $LINENO "Something wrong happened with installing apt dependencies."
