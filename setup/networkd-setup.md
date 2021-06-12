# networkd-setup

Templates for setting up systemd-networkd.

## Wireless network
```
# /etc/wpa_supplicant/wpa_supplicant@wlan0.conf
ctrl_interface=/run/wpa_supplicant
update_config=1

# Can generate using function wpa_passphrase
network={
        ssid="ssid"
        psk="password"
}

# /etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes

# systemctl restart systemd-networkd
# systemctl restart systemd-resolved 
```

## Bridge Network
```
# /etc/systemd/network/br0.netdev
[NetDev]
Name=br0
Kind=bridge

# /etc/systemd/network/br0-bind.network
[Match]
Name=en*

[Network]
Bridge=br0

# /etc/systemd/network/br0.network
[Match]
Name=br0

[Network]
DHCP=ipv4
MulticastDNS=yes

# systemctl restart systemd-networkd
# systemctl restart systemd-resolved 
```
