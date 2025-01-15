{
  delib,
  inputs,
  constants,
  ...
}:
delib.module {
  name = "persist";

  options.persist = with delib; {
    enable = boolOption false;
    persistPath = noDefault (strOption null);

    directories = listOfOption str [ ];
    files = listOfOption str [ ];

    user = {
      directories = listOfOption str [ ];
      files = listOfOption str [ ];
    };
  };

  nixos.always.imports = [ inputs.impermanence.nixosModules.impermanence ];
  home.always.imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  nixos.ifEnabled =
    { cfg, ... }:
    {
      environment.persistence.${cfg.persistPath} = {
        enable = true;
        hideMounts = true;

        directories = [
          "/var/lib/nixos"
        ] ++ cfg.directories;
        files = [
          "/etc/machine-id"
        ] ++ cfg.files;

        users.${constants.username} = {
          directories = [
            "nix-config"
          ] ++ cfg.user.directories;

          inherit (cfg.user) files;
        };
      };
    };
}
