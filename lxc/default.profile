# EDITOR=vim lxc profile edit default

config:
  raw.idmap: both 1000 1000
description: ""
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
name: default
used_by:
- /1.0/instances/rmf

