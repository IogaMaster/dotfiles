{ lib, config, pkgs, modulesPath, ... }: {
  imports = [ "${toString modulesPath}/profiles/qemu-guest.nix" ];

  formatAttr = lib.mkForce "qcow";

  system.build.qcow = lib.mkForce
    (import "${pkgs.path}/nixos/lib/make-disk-image.nix" {
      inherit lib config pkgs;
      diskSize = "auto";
      memSize = "2048";
      format = "qcow2";
      partitionTableType = "legacy";
      additionalSpace = "256M";
      copyChannel = false;

      postVM = ''
        echo "Compressing final image with zstd..."
        ${pkgs.qemu-utils}/bin/qemu-img convert -c -O qcow2 -o compression_type=zstd "$diskImage" "$out/nixos-minimal.qcow2"
        rm "$diskImage"
      '';
    });

  # Standard minimal ext4 filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # Simplest bootloader for a "legacy" partition table
  boot.loader.grub = {
    enable = lib.mkForce true;
    device = "/dev/vda";
    efiSupport = lib.mkForce false;
  };

  hardware.enableRedistributableFirmware = false;
  fonts.fontconfig.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    dhcpcd.wait = "background";
  };
  boot.initrd.availableKernelModules =
    [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_ring" ];

  # Minimize closure size
  documentation.enable = false;
  environment.defaultPackages = lib.mkForce [ ];
  programs.command-not-found.enable = false;
}
