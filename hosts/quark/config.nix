{ lib, inputs, ... }:
let hostJson = builtins.fromJSON (builtins.readFile ./host.tf.json);
in {
  imports = [
    inputs.disko.nixosModules.disko
    (import "${inputs.self}/disks/impermanence.nix" {
      inherit lib;
      device = "/dev/vda";
    })
  ];
  # hardware.facter.reportPath = ./facter.json;
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules =
    [ "nvme" "xen_blkfront" "virtio_pci" "virtio_scsi" ];

  networking = {
    hostName = hostJson.hostname;
    useDHCP = lib.mkDefault true;
    interfaces.enp0s3.useDHCP = lib.mkDefault true;
  };

  ioga = {
    hardware = { audio.enable = true; };
    apps.tools.git.enable = true;
  };

  impermanence.enable = true;
}
