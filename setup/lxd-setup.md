# LXD Setup
```
pacman -S lxc arch-install-scripts lxd
systemctl start lxd.service	# And enable it
lxd init
usermod -aG lxd arch
```

# Add the following to /etc/pam.d/system.login
```
session    optional   pam_cgfs.so -c freezer,memory,name=systemd,unified
```

# Add the following to /etc/lxc/defaul.tconf
```
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536
```

# Add the following to /etc/subuid and /etc/subgid
root:100000:65536

# Modify GRUB_CMDLINE_LINUX_DEFAULT as following
```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet systemd.unified_cgroup_hierarchy=0"
grub-mkconfig -o /boot/grub/grub.cfg
```

# Set default DNS for lxdbr0 network
lxc network set lxdbr0 raw.dnsmasq dhcp-option=6,8.8.8.8,8.8.4.4

# Add the following to /etc/systemd/network/lxdbr0.network to enable mDNS
```
[Match]
Name=lxdbr0

[Network]
MulticastDNS=yes
```
# Setup SSH keys
```
ssh-keygen -f $HOME/.ssh/id_rsa_lxd
lxc exec [container-name] -- su --login ubuntu bash -c "echo $(cat $HOME/.ssh/id_rsa_lxd.pub) >> /home/ubuntu/.ssh/authorized_keys" 
```

