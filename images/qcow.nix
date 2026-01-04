{ lib, config, pkgs, modulesPath, ... }: {
  imports = [ "${toString modulesPath}/profiles/qemu-guest.nix" ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };
  boot.growPartition = true;
  environment.systemPackages = [ pkgs.cloud-utils ];

  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = "auto";
    additionalSpace = "512M";
    format = "qcow2-compressed";
    partitionTableType = "hybrid";
  };

  boot = {
    kernelParams = [ "console=ttyS0" ];
    loader = {
      grub = {
        device = lib.mkDefault "/dev/vda";
        efiInstallAsRemovable = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = lib.mkForce false;
    };
  };
}
