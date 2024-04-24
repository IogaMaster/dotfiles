{
  lib,
  inputs,
  ...
}:
with lib; rec {
  mkSystem = name: description: options:
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
    config =
      {
        imports = with inputs; [nix-topology.nixosModules.default];
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
        };
      }
      // options;
  };
}
