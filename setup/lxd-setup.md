# LXD Setup
```
pacman -S lxc arch-install-scripts lxd
systemctl start lxd.service	# And enable it
lxd init
usermod -aG lxd arch
```

#### Change occurances of 1000 to 100000 for unprivileged containers
#### Add the following to /etc/pam.d/system-login
```
session    optional   pam_cgfs.so -c freezer,memory,name=systemd,unified
```

#### Add the following to /etc/lxc/default.conf
```     
lxc.idmap = u 0 1000 65536
lxc.idmap = g 0 1000 65536
```

#### Add the following to /etc/subuid and /etc/subgid
````
root:1000:65536
```

#### Modify GRUB_CMDLINE_LINUX_DEFAULT as following
```
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet systemd.unified_cgroup_hierarchy=0"
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Use the setup script functions to set up LXC profiles, network, storage, etc
```
source scripts/lxc_setup
lxc_setup_all
```

#### Setup SSH keys
```
ssh-keygen -f $HOME/.ssh/id_rsa_lxd
lxc exec [container-name] -- su --login ubuntu bash -c "echo $(cat $HOME/.ssh/id_rsa_lxd.pub) >> /home/ubuntu/.ssh/authorized_keys" 
```

#### Create container and add profiles
```
lxc launch ubuntu:20.04 container-name
lxc profile assign default,hostbridge,display
```

#### Copy profiles to scale up
```
lxc copy container container-alt
lxc start container-alt
```
#### Expose / Forward Ports from container to host
```
lxc config device add keycloak keycloak8080 proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:8080
```
