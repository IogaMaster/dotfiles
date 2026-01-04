{ lib, pkgs, modulesPath, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];
  boot.kernelParams = [ "console=ttyS0" ];
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  environment.systemPackages = with pkgs; [ git vim parted gptfdisk ];
}
