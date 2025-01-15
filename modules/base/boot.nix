{ delib, ... }:
delib.module {
  name = "boot";

  options.boot = with delib; {
    enable = boolOption true;

    mode = enumOption [ "uefi" "legacy" ] (
      if builtins.pathExists /sys/firmware/efi/efivars then "uefi" else "legacy"
    );
  };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      boot.loader = {
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
    };
}
