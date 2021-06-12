# Vim Setup
Setup Vim with minimal configurations and plugins.

## Install vim
```
pacman -S gvim ctags fzf ripgrep
```
## Optionally, install plugins
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash                 # For plugins with node dependencies
nvm install --lts

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim        # vim-plug
pacman -S flake8 autopep8 rustfmt shfmt clang
```

## Follow up
```
# coc-nvim: https://github.com/neoclide/coc.nvim/wiki/Language-servers
```
