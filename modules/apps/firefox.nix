{ lib, config, pkgs, ... }@args:
lib.mkModule args "ioga.apps.firefox" {
  config = { cfg }: {
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
    };
    home.persist.directories = [ ".librewolf" ".cache/librewolf" ];
  };
}
