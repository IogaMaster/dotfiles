<h1 align="center"> <img src="./.github/assets/flake.webp" width="250px"/></h1>
<h2 align="center">My NixOS flake built with <a href="https://github.com/snowfallorg/lib">snowfall</a>.</h2>

<h1 align="center">
<a href='#'><img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px"/></a>
  <br>
  <br>
  <div>
    <a href="https://github.com/Iogamaster/dotfiles/issues">
        <img src="https://img.shields.io/github/issues/Iogamaster/dotfiles?color=fab387&labelColor=303446&style=for-the-badge">
    </a>
    <a href="https://github.com/Iogamaster/dotfiles/stargazers">
        <img src="https://img.shields.io/github/stars/Iogamaster/dotfiles?color=ca9ee6&labelColor=303446&style=for-the-badge">
    </a>
    <a href="https://github.com/Iogamaster/dotfiles">
        <img src="https://img.shields.io/github/repo-size/Iogamaster/dotfiles?color=ea999c&labelColor=303446&style=for-the-badge">
    </a>
    <a href="https://github.com/Iogamaster/dotfiles/blob/main/.github/LICENCE">
        <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=ca9ee6&colorA=313244&colorB=cba6f7"/>
    </a>
    <br>
    </div>
        <img href="https://builtwithnix.org" src="https://builtwithnix.org/badge.svg"/>
   </h1>
   <br>

![image](https://github.com/IogaMaster/dotfiles/assets/67164465/1605c3d2-ca38-4942-a2f5-a1288c19d8e3)

<details>
<summary>🖼️ Gallery</summary>

![image](https://github.com/IogaMaster/dotfiles/assets/67164465/83bc1ff5-74d6-4043-8def-9f5e971a801f)
![image](https://github.com/IogaMaster/dotfiles/assets/67164465/dac697f5-870f-42bd-9b5e-f35c019f96e1)

</details>

## My system management tool `sys`

`sys` is a bash script I made that makes working with NixOS easier.

Rebuild (in flake directory)

```sh
sudo sys rebuild # or `r` as a shorthand
```

Testing an ephemeral config:

```sh
sudo sys test # or `t` as a shorthand
```

Deploying to a server (in flake directory):

```sh
sudo sys deploy HOSTNAME # or `d` as a shorthand
```

______________________________________________________________________

<details>
<summary><b><font size="+3">Installing</font></b></summary>

### Build install iso

```sh
# Graphical
nix build .#install-isoConfigurations.graphical

# Minimal tty
nix build .#install-isoConfigurations.minimal
```

### Basic Setup

Network manager is installed by default.
If you need wifi.

```sh
nmtui
```

Now become root.

```sh
sudo su
```

### Disks

This is pretty much copy and paste.

<details>
<summary>UEFI</summary>

```sh
# Become root
sudo su

# Assuming /dev/sda is the device you are installing to.
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

# Make filesystems and mount
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
```

</details>

<details>
<summary>BIOS</summary>

```sh
# Become root
sudo -i

# Assuming /dev/sda is the device you are installing to.
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

# Make filesystems and mount
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
```

</details>

### Final install

Now we need to add your system.

First clone the dotfiles in `/mnt`

```sh
git clone git@github.com:IogaMaster/dotfiles /mnt/.dotfiles
cd /mnt/.dotfiles/
```

Then copy the example config with the new hostname of your system.

```sh
# The `x86_64-linux` part comes from nixos generators, if you are using a different arch use that directory. eg `aarch64-linux` for arm
cp -r systems/x86_64-linux/example/ systems/x86_64-linux/hostname
```

> \[!WARNING\]\
> Do not use my hardware configurations they won't work with your system!

Generate your config and copy the hardware configuration.

```sh
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/.dotfiles/systems/x86_64-linux/hostname/
```

Then install.

```sh
nixos-install
```

### Post install.

> \[!WARNING\]\
> The default password for the iogamaster user is `password` please change it.

I normally clone the dotfiles repo to ~/.dotfiles/

</details>

______________________________________________________________________

A special thanks to:

[hlissner](https://github.com/hlissner/dotfiles) for getting me into NixOS.

[redyf](https://github.com/redyf/nixdots) for the bar and other minor hyprland config options.

[Wil Taylor](https://www.youtube.com/playlist?list=PL-saUBvIJzOkjAw_vOac75v-x6EzNzZq-) for his youtube series on setting up NixOS with a flake.

[Jake Hamilton](https://github.com/jakehamilton/config) for his NixOS config and [snowfall](https://github.com/snowfallorg/lib).
