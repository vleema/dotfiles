# Arch linux installation guide (UEFI, BTRFS)

> Mostly copy pasted from <https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae>

Before following this guide, make sure you have disabled **Secure Boot** and booted into the installation media in **UEFI** mode. If you don't know how to do this, read the [UEFI section](https://wiki.archlinux.org/title/Installation_guide#UEFI) of the Arch Linux wiki.

## Table of contents

<!--toc:start-->

- [Arch linux installation guide (UEFI, BTRFS)](#arch-linux-installation-guide-uefi-btrfs)
  - [Table of contents](#table-of-contents)
- [Preliminary steps](#preliminary-steps)
  - [Wifi Connection](#wifi-connection)
  - [Installation using ssh](#installation-using-ssh)
    - [Ssh](#ssh)
    - [Tmux](#tmux)
- [Main installation](#main-installation)
  - [Disk partitioning](#disk-partitioning)
  - [Disk formatting](#disk-formatting)
  - [Disk mounting](#disk-mounting)
  - [Packages installation](#packages-installation)
  - [Fstab](#fstab)
  - [Context switch to our new system](#context-switch-to-our-new-system)
  - [Set up the time zone](#set-up-the-time-zone)
  - [Set up the language and tty keyboard map](#set-up-the-language-and-tty-keyboard-map)
  - [Hostname and Host configuration](#hostname-and-host-configuration)
  - [Root and users](#root-and-users)
  - [Grub configuration](#grub-configuration)
    - [Hibernation](#hibernation)
    - [OS-Prober](#os-prober)
  - [Unmount everything and reboot](#unmount-everything-and-reboot)
  - [Automatic snapshot boot entries update](#automatic-snapshot-boot-entries-update)
  - [Aur helper and additional packages installation](#aur-helper-and-additional-packages-installation)
  - [System Optimization and Configuration](#system-optimization-and-configuration)
  - [Finalization](#finalization)
  - [Post-Installation System Optimization](#post-installation-system-optimization)
  - [Timeshift first snapshot](#timeshift-first-snapshot)
  <!--toc:end-->

# Preliminary steps

First set up your keyboard layout

```Zsh
# List all the available keyboard maps and filter them through grep, in this case i am looking for an italian keyboard, which usually starts with "it", for english filter with "en"
ls /usr/share/kbd/keymaps/**/*.map.gz | grep it

# If you prefer you can scroll the whole list like this
ls /usr/share/kbd/keymaps/**/*.map.gz | less

# Or like this
localectl list-keymaps

# Now get the name without the path and the extension ( localectl returns just the name ) and load the layout. In my case it is simply "it"
loadkeys it
```

Check that we are in UEFI mode

```Zsh
# If this command prints 64 or 32 then you are in UEFI
cat /sys/firmware/efi/fw_platform_size
```

Check the internet connection

```Zsh
ping -c 5 archlinux.org
```

Check the system clock

```Zsh
# Check if ntp is active and if the time is right
timedatectl

# In case it's not active you can do
timedatectl set-ntp true

# Or this
systemctl enable systemd-timesyncd.service
```

## Wifi Connection

Run

```Zsh
iwctl
```

List available devices

```Zsh
device list
```

Power on the device with

```Zsh
device <device_name> set-property Powered true
```

Scan for networks with

```Zsh
station <device_name> scan
```

exit

## Installation using ssh

### Ssh

In the target machine, run the following

```Zsh
# Setup a password, could be any, will be temporary
passwd

# Output the ip address with
ip add
```

In the host machine, connect with

```Zsh
ssh root@<ip_address>
```

### Tmux

> This is personal preference

Change the default tmux key binding to `Ctrl + a` instead of `Ctrl + b` by adding the following line to your `~/.tmux.conf` file:

```Zsh
set -g default-terminal "tmux-256color"
set -s escape-time 0
set -g base-index 1

unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# vi key movement for copy/pasta mode
set-window-option -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'

# Open new windows and panes in the current working directory of the active
# pane.
bind c new-window -c "#{pane_current_path}"
# split panes using | and -
bind '|' split-window -h -c "#{pane_current_path}"
bind - split-window  -c "#{pane_current_path}"
bind '"' split-window -h
bind % split-window
```

Setup a tmux session:

```Zsh
tmux
```

# Main installation

## Disk partitioning

I will make 3 partitions:

| Number | Type             | Size                            |
| ------ | ---------------- | ------------------------------- |
| 1      | EFI              | At least 1GB                    |
| 2      | Linux Filesystem | Any                             |
| 3      | Linux Swap       | The size of RAM or sligtly less |

First check the size that you need for the swap partition:

```Zsh
cat /sys/power/image_size
```

This will output the size in bytes, divide by 1024^3 to get in gigabytes.

```Zsh
cfdisk /dev/nvme0n1
```

## Disk formatting

For the file system I've chosen [**BTRFS**](https://wiki.archlinux.org/title/Btrfs) which has evolved quite a lot in the recent years. It is most known for its **Copy on Write** feature which enables it to make system snapshots in a blink of a an eye and to save a lot of disk space, which can be even saved to a greater extent by enabling built\-in **compression**. Also it lets the user create **subvolumes** which can be individually snapshotted.

```Zsh
# Find the efi partition with fdisk -l or lsblk. For me it's /dev/nvme0n1p1 and format it.
mkfs.fat -F 32 /dev/nvme0n1p1

# Find the root partition. For me it's /dev/nvme0n1p2 and format it. I will use BTRFS.
mkfs.btrfs /dev/nvme0n1p2

# Format the swap
mkswap /dev/nvme0n1p3

# Say that swap is there
swapon /dev/nvme0n1p3

# Mount the root fs to make it accessible
mount /dev/nvme0n1p2 /mnt

```

## Disk mounting

I will lay down the subvolumes on a **flat** layout, which is overall superior in my opinion and less constrained than a **nested** one. What's the difference ? If you're interested [this section of the old sysadmin guide](https://archive.kernel.org/oldwiki/btrfs.wiki.kernel.org/index.php/SysadminGuide.html#Layout) explains it.

```Zsh
# Create the subvolumes, in my case I choose to make a subvolume for / and one for /home. Subvolumes are identified by prepending @
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@tmp

# Unmount the root fs
umount /mnt
```

For this guide I'll compress the btrfs subvolumes with **Zstd**, which has proven to be [a good algorithm among the choices](https://www.phoronix.com/review/btrfs-zstd-compress)

```Zsh
# Mount the root and home subvolume with optimized BTRFS options for performance
# compress=zstd:1 - balanced compression level
# noatime - don't update access times for better performance
# ssd - SSD optimizations
# discard=async - asynchronous TRIM for SSDs
# space_cache=v2 - improved free space tracking
# autodefrag - automatic defragmentation for small files
mount -o compress=zstd:3,noatime,ssd,discard=async,space_cache=v2,autodefrag,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/home /mnt/var /mnt/tmp
mount -o compress=zstd:3,noatime,ssd,discard=async,space_cache=v2,autodefrag,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o compress=zstd:3,noatime,ssd,discard=async,space_cache=v2,autodefrag,subvol=@var /dev/nvme0n1p2 /mnt/var
mount -o compress=zstd:3,noatime,ssd,discard=async,space_cache=v2,autodefrag,subvol=@tmp /dev/nvme0n1p2 /mnt/tmp
```

Now we have to mount the efi partition. In general there are 2 main mountpoints to use: `/efi` or `/boot` but in this configuration i am **forced** to use `/efi`, because by choosing `/boot` we could experience a **system crash** when trying to restore `@` _\( the root subvolume \)_ to a previous state after kernel updates. This happens because `/boot` files such as the kernel won't reside on `@` but on the efi partition and hence they can't be saved when snapshotting `@`. Also this choice grants separation of concerns and also is good if one wants to encrypt `/boot`, since you can't encrypt efi files. Learn more [here](https://wiki.archlinux.org/title/EFI_system_partition#Typical_mount_points)

```Zsh
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
```

## Packages installation

```Zsh
# This will install some packages to "bootstrap" methaphorically our system. Feel free to add the ones you want
# "base, linux, linux-firmware" are needed. If you want a more stable kernel, then swap linux with linux-lts
# "base-devel" base development packages
# "git" to install the git vcs
# "btrfs-progs" are user-space utilities for file system management ( needed to harness the potential of btrfs )
# "grub" the bootloader
# "efibootmgr" needed to install grub
# "grub-btrfs" adds btrfs support for the grub bootloader and enables the user to directly boot from snapshots
# "inotify-tools" used by grub btrfsd deamon to automatically spot new snapshots and update grub entries
# "timeshift" a GUI app to easily create,plan and restore snapshots using BTRFS capabilities
# "amd-ucode" microcode updates for the cpu. If you have an intel one use "intel-ucode"
# "neovim" my goto editor, if unfamiliar use nano
# "networkmanager" to manage Internet connections both wired and wireless ( it also has an applet package network-manager-applet )
# "pipewire pipewire-alsa pipewire-pulse pipewire-jack" for the new audio framework replacing pulse and jack.
# "wireplumber" the pipewire session manager.
# "reflector" to manage mirrors for pacman
# "zsh" my favourite shell
# "zsh-completions" for zsh additional completions
# "zsh-autosuggestions" very useful, it helps writing commands [ Needs configuration in .zshrc ]
# "openssh" to use ssh and manage keys
# "man" for manual pages
# "sudo" to run commands as other users
# "util-linux" contains fstrim for SSD maintenance
pacstrap -K /mnt base base-devel linux linux-firmware git btrfs-progs grub efibootmgr grub-btrfs inotify-tools timeshift amd-ucode neovim networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber reflector zsh zsh-completions zsh-autosuggestions openssh man sudo util-linux
```

## Fstab

```Zsh
# Fetch the disk mounting points as they are now ( we mounted everything before ) and generate instructions to let the system know how to mount the various disks automatically
genfstab -U /mnt >> /mnt/etc/fstab

# Check if fstab is fine ( it is if you've faithfully followed the previous steps )
cat /mnt/etc/fstab
```

## Context switch to our new system

```Zsh
# To access our new system we chroot into it
arch-chroot /mnt
```

## Set up the time zone

```Zsh
# In our new system we have to set up the local time zone, find your one in /usr/share/zoneinfo mine is /usr/share/zoneinfo/America/Fortaleza and create a symbolic link to /etc/localtime
ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime

# Now sync the system time to the hardware clock
hwclock --systohc
```

## Set up the language and tty keyboard map

Edit `/etc/locale.gen` and uncomment the entries for your locales. Each entry represent a language and its formats for time, date, currency and other country related settings. By uncommenting we will mark the entry to be generated when the generate command will be issued, but note that it won't still be active. In my case I will uncomment _\( ie: remove the # \)_ `en_US.UTF-8 UTF-8` and `it_IT.UTF-8 UTF-8` because I use English as a display language and Italian for date, time and other formats.

```Zsh
# To edit I will use vim, feel free to use nano instead.
nvim /etc/locale.gen

# Now issue the generation of the locales
locale-gen
```

Since the locale is generated but still not active, we will create the configuration file `/etc/locale.conf` and set the locale to the desired one, by setting the `LANG` variable accordingly. In my case I'll write `LANG=en_US.UTF-8`

```Zsh
touch /etc/locale.conf
nvim /etc/locale.conf
```

Now to make the current keyboard layout permanent for tty sessions , create `/etc/vconsole.conf` and write `KEYMAP=your_key_map` substituting the keymap with the one previously set [here](#preliminary-steps). In my case `KEYMAP=it`

```Zsh
nvim /etc/vconsole.conf
```

## Hostname and Host configuration

```Zsh
# Create /etc/hostname then choose and write the name of your pc in the first line. In my case I'll use Arch
touch /etc/hostname
nvim /etc/hostname

# Create the /etc/hosts file. This is very important because it will resolve the listed hostnames locally and not over Internet DNS.
touch /etc/hosts
```

Write the following ip, hostname pairs inside /etc/hosts, replacing `Arch` with **YOUR** hostname:

```
127.0.0.1 localhost
::1 localhost
127.0.1.1 Arch
```

```Zsh
# Edit the file with the information above
vim /etc/hosts
```

## Root and users

```Zsh
# Set up the root password
passwd

# Add a new user, in my case mjkstra.
# -m creates the home dir automatically
# -G adds the user to an initial list of groups, in this case wheel, the administration group. If you are on a Virtualbox VM and would like to enable shared folders between host and guest machine, then also add the group vboxsf besides wheel.
useradd -mG wheel leema
passwd leema

# The command below is a one line command that will open the /etc/sudoers file with your favourite editor.
# You can choose a different editor than vim by changing the EDITOR variable
# Once opened, you have to look for a line which says something like "Uncomment to let members of group wheel execute any action"
# and uncomment exactly the line BELOW it, by removing the #. This will grant superuser priviledges to your user.
# Why are we issuing this command instead of a simple vim /etc/sudoers ?
# Because visudo does more than opening the editor, for example it locks the file from being edited simultaneously and
# runs syntax checks to avoid committing an unreadable file.
EDITOR=nvim visudo
```

## Grub configuration

Now I'll [deploy grub](https://wiki.archlinux.org/title/GRUB#Installation)

```Zsh
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
```

Generate the grub configuration ( it will include the microcode installed with pacstrap earlier )

```Zsh
grub-mkconfig -o /boot/grub/grub.cfg
```

### Hibernation

Identify swap partition UUID

```Zsh
blkid /dev/nvme0n1p3
```

Put the UUID in `/etc/default/grub` file, by adding `resume=UUID=<swap_partition_uuid>` to the `GRUB_CMDLINE_LINUX_DEFAULT` line. For example:

```plain
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=<uuid2>
```

Also add the `resume` hook before `filesystem` to the `HOOKS` line in `/etc/mkinitcpio.conf`, so it looks like this:

```plain
HOOKS=(... resume filesystems ...)
```

### OS-Prober

This is for dual boot systems, where you have more than one operating system installed on the machine. The `os-prober` package is used to detect other operating systems and add them to the GRUB menu.

Make sure that the line `GRUB_DISABLE_OS_PROBER=false` is present in `/etc/default/grub`, this will enable the detection of other operating systems installed on the machine, such as Windows or other Linux distributions.

## Unmount everything and reboot

```Zsh
# Enable newtork manager before rebooting otherwise, you won't be able to connect
systemctl enable NetworkManager

# Exit from chroot
exit

# Unmount everything to check if the drive is busy
umount -R /mnt

# Reboot the system and unplug the installation media
reboot

# Now you'll be presented at the terminal. Log in with your user account, for me its "mjkstra".

# Enable and start the time synchronization service
timedatectl set-ntp true
```

## Automatic snapshot boot entries update

Each time a system snapshot is taken with timeshift, it will be available for boot in the bootloader, however you need to manually regenerate the grub configuration, this can be avoided thanks to `grub-btrfs`, which can automatically update the grub boot entries.

Edit the **`grub-btrfsd`** service and because I will rely on timeshift for snapshotting, I am going to replace `ExecStart=...` with `ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto`. If you don't use timeshift or prefer to manually update the entries then lookup [here](https://github.com/Antynea/grub-btrfs)

```Zsh
sudo systemctl edit --full grub-btrfsd

# Enable grub-btrfsd service to run on boot
sudo systemctl enable grub-btrfsd
```

## Aur helper and additional packages installation

To gain access to the arch user repository we need an aur helper, I will choose yay which also works as a pacman wrapper \( which means you can use yay instead of pacman \). Yay has a CLI, but if you later want to have an aur helper with a GUI you can install [`pamac`](https://gitlab.manjaro.org/applications/pamac) \( a Manjaro software, so use at your own risk \), **however** note that front\-ends like `pamac` and also any store \( KDE discovery, Ubuntu store etc. \) are not officially supported and should be avoided, because of the high risk of performing [partial upgrades](https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported). This is also why later when installing KDE, I will exclude the KDE discovery store from the list of packages.

> Note: you can't execute makepkg as root, so you need to log in your main account. For me it's leema

```Zsh
# Install yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si

# Install "timeshift-autosnap", a configurable pacman hook which automatically makes snapshots before pacman upgrades.
paru -S timeshift-autosnap
```

> Learn more about timeshift autosnap [here](https://gitlab.com/gobonja/timeshift-autosnap)

## System Optimization and Configuration

Before rebooting, let's optimize pacman and set up system maintenance:

```Zsh
# Set up reflector for automatic mirror updates
echo "--save /etc/pacman.d/mirrorlist" > /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--country BR,AR,CL,UY,US" >> /etc/xdg/reflector/reflector.conf
echo "--latest 20" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf

# Enable reflector timer for weekly mirror updates
systemctl enable reflector.timer

# Enable SSD TRIM support
systemctl enable fstrim.timer

# Enable BTRFS scrubbing for data integrity
systemctl enable btrfs-scrub@-.timer
```

## Finalization

```Zsh
# To complete the main/basic installation reboot the system
reboot
```

> After these steps you **should** be able to boot on your newly installed Arch Linux, if so congrats !

## Post-Installation System Optimization

After your first boot, run these additional optimization commands:

```Zsh
# Update mirror list with reflector
sudo reflector --country BR,AR,CL,UY,US --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Clean package cache to save space
sudo paccache -r

# Check BTRFS filesystem health
sudo btrfs filesystem show
sudo btrfs filesystem usage /
```

## Timeshift first snapshot

```Zsh
# You can now run timeshift to create your first snapshot.
timeshift --create --comments "Minimal installation" --tags D
```
