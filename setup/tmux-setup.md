# Tmux Setup

## Install tmux
```
pacman -S tmux
```

## Set up Tmux Plugin Manager
```
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm 
```

## Set up bash completion for tmux 
```
curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux | sudo tee -a /usr/share/bash-completion/completions/tmux
```
