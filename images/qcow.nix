{ lib, config, pkgs, modulesPath, ... }: {
  imports = [ "${toString modulesPath}/profiles/qemu-guest.nix" ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };
  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = 10240;
    format = "qcow2";
    partitionTableType = "hybrid";
  };
  boot = {
    kernelParams = [ "console=ttyS0" ];
    loader = {
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = lib.mkForce false;
    };
  };
}
