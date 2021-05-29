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
