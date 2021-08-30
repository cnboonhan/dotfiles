#!/usr/bin/env bash
# shellcheck source=/home/ubuntu/.bashrc

# exit codes:
#   0: success
#   1: general error exit
#   2: lockfile present

set -o errexit
set -o nounset
set -o pipefail

export PROJECT=extras-setup
SCRIPTPATH="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"
. "$SCRIPTPATH/utils.bash"

[ "$EUID" -ne 0 ] && echo "Please run as root." && exit 1

apt update

__msg_info "Installing.."

apt install screenkey -y
curl -sS https://webinstall.dev/zoxide | bash || __error_exit $LINENO "Failed to install zoxide"
VERSION=0.11.9; ( wget "https://github.com/dalance/procs/releases/download/v$VERSION/procs-v$VERSION-x86_64-lnx.zip" -O /tmp/procs.zip && \
    unzip /tmp/procs.zip -d /usr/local/bin ) || __error_exit $LINENO "Failed to install procs"
VERSION=0.6.2; ( wget "https://github.com/bootandy/dust/releases/download/v$VERSION/dust-v$VERSION-x86_64-unknown-linux-gnu.tar.gz" -O /tmp/dust.tar.gz && \
    mkdir -p /tmp/dust && tar -xzvf /tmp/dust.tar.gz -C /tmp/dust  --strip-components 1 && mv /tmp/dust/dust /usr/local/bin ) || __error_exit $LINENO "Failed to install dust":w
VERSION=0.6.3; ( curl -LO "https://github.com/ClementTsang/bottom/releases/download/$VERSION/bottom_${VERSION}_amd64.deb" && \
    dpkg -i "bottom_${VERSION}_amd64.deb" && \
    rm "bottom_${VERSION}_amd64.deb" ) || __error_exit $LINENO "bottom failed to install"
VERSION=0.8.3; ( wget "https://github.com/dandavison/delta/releases/download/$VERSION/git-delta_${VERSION}_amd64.deb" && \
    dpkg -i "git-delta_${VERSION}_amd64.deb" && \
    rm "git-delta_${VERSION}_amd64.deb" ) || __error_exit $LINENO "delta failed to install"

printf "Place this in ~.gitconfig to use delta.\n"
cat << EOF
[pager]
    diff = delta
    log = delta
    reflog = delta
    show = delta

[delta]
    plus-style = "syntax #012800"
    minus-style = "syntax #340001"
    syntax-theme = Monokai Extended
    navigate = true

[interactive]
    diffFilter = delta --color-only
EOF
