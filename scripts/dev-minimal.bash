#!/usr/bin/env bash
# shellcheck source=/home/ubuntu/.bashrc

# exit codes:
#   0: success
#   1: general error exit
#   2: lockfile present

set -o errexit
set -o nounset
set -o pipefail

export PROJECT=dev-minimal-setup
SCRIPTPATH="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"
. "$SCRIPTPATH/utils.bash"

declare -a DEPENDS=(
    "curl" "wget" "git" "vim"
)

for depend in "${DEPENDS[@]}"; do
    dpkg -s "$depend" >/dev/null 2>&1 || __error_exit $LINENO "$depend is required."
done
__msg_info "All apt dependencies found."

__msg_info "Installing NodeJS"
[ -f "$HOME/.nvm/nvm.sh" ] ||
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash ||
    error_exit $LINENO "Unable to install NVM"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
command -v "node" >/dev/null 2>&1 ||
    nvm install --lts ||
    __error_exit $LINENO "Unable to install node"

__msg_info "Installing vim-plug"
[ -f "$HOME/.vim/autoload/plug.vim" ] ||
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ||
    __error_exit $LINENO "Unable to install vim-plug"

__msg_info "Copying vim config files and installing, might take a while."
{ cp "$SCRIPTPATH/../_vimrc" "$HOME/.vimrc" && cp "$SCRIPTPATH/../_vimrc_plugins" "$HOME/.vimrc_plugins"; } ||
    __error_exit $LINENO "Error copying config files"

vim -c PlugInstall -c qall!
