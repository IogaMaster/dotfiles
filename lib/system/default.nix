{ lib, inputs, ... }:
with lib;
let
  generateMacAddress =
    s:
    let
      hash = builtins.hashString "sha256" s;
      c = off: builtins.substring off 2 hash;
    in
    "${builtins.substring 0 1 hash}2:${c 2}:${c 4}:${c 6}:${c 8}:${c 10}";
in
rec {
  mkSystem =
    name: description: options:
    {
      topology.self = {
        inherit name;
        hardware.info = description;
      };

      suites.common.enable = true;
      suites.development.enable = true;

      # ======================== DO NOT CHANGE THIS ========================
      system.stateVersion = "24.05";
      # ======================== DO NOT CHANGE THIS ========================
    }
    // options;

  mkMicrovm = name: options: {
    config = {
      imports = with inputs; [ nix-topology.nixosModules.default ];
      microvm = {
        hypervisor = "cloud-hypervisor";
        vcpu = 2;
        mem = 1024 * 2;
        shares = [
          {
            # Without sharing the hosts /nix/store, the images will be MASSIVE.
            proto = "virtiofs";
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          }
        ];

        interfaces = [
          {
            type = "tap";
            id = builtins.substring 0 15 "vm-${name}";
            mac = generateMacAddress "vm-${name}";
          }
        ];
      };
    } // options;
  };
}
