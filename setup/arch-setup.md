# Setup Notes for a new Arch Linux Install

## Prepare USB
```
# Download Arch Linux .iso
# Figure out which device is the USB: lsblk
cp archlinux.iso  /dev/sda
```

## Boot USB
```
# You might need to change the boot order in BIOS
```

## Arch Linux Boostrap
```
# Clear Partitions
fdisk -l
fdisk /dev/nvme0n1
# Delete all partitions: d <CR> until empty;
# Create new Partition for EFI: n <CR> <CR> +512 <CR> y <CR> t <CR> 1 <CR>
# Create new Partition for root: <CR> <CR> <CR> y <CR> 
# Write Partitions: w <CR>

# Format Partitions
mkfs.fat /dev/nvme0n1p1
mkfs.ext4 hdev/nvme0n1p2

# Mount Partitions
mount /dev/nvme0n1p2 /mnt

# Connect to Network
iwctl       # station wlan0 connect [wifi]

# Bootstrap Arch
pacstrap /mnt base linux linux-firmware vim tmux wpa_supplicant sudo 

# Generate mount configuration at boot
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into arch and do setup
arch-chroot /mnt
# Uncomment en_US.UTF-8 in /etc/locale.gen
locale-gen    
Edit /etc/hostname
Edit /etc/hosts

# Install GRUB ( while in arch-chroot )
pacman -S grub efibootmgr os-prober
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# Edit sudoers file to allow wheel users sudo access
EDITOR=vim visudo /etc/sudoers

# Optionally create new user arch
useradd -m -G wheel -s /bin/bash arch
passwd arch

# Restart and remove USB
```
## Network Setup
```
# Set up network as root
wpa_passphrase [ssid] [psk] > /etc/wpa_supplicant/wpa_supplicant-[iface].conf
systemctl start wpa_supplicant@[iface]

# Add the following config into /etc/systemd/network/[iface].network
'''
[Match]
Name=[iface]

[Network]
DHCP=yes
'''
systemctl start systemd-networkd

systemctl start systemd-resolved
# ping check
# Run enable on all systemctl if successful
```
# AUR Setup
```
pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
## GUI Setup
```
pacman -S xorg xorg-xinit
cd /usr/src
git clone git://git.suckless.org/dwm
git clone git://git.suckless.org/st
git clone git://git.suckless.org/dmenu
cd dwm && make clean install
cd st && make clean install
cd dmenu && make clean install
echo "exec dwm" >> ~/.xinitrc
startx
```
## Add Bash Completion
sudo pacman -S bash-completion
echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc
