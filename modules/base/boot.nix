{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "boot";

  options.boot = with delib; {
    enable = boolOption true;

    mode = enumOption [ "uefi" "legacy" ] (
      if builtins.pathExists /sys/firmware/efi/efivars then "uefi" else "legacy"
    );
  };

  nixos.always.imports = [ inputs.nixos-boot.nixosModules.default ];

  nixos.ifEnabled =
    { cfg, ... }:
    {

      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
          };

          grub = {
            enable = true;
            efiSupport = cfg.mode == "uefi";
            devices = [ "nodev" ];
            configurationLimit = 1;
          };

          timeout = 0;
        };
        vesa = true;
      };

      nixos-boot = {
        enable = true;
        bgColor = {
          # catppucin-mocha crust
          red = 17;
          green = 17;
          blue = 27;
        };
        duration = 3.5;
      };
    };
}
