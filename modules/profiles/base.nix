{ lib, ... }@args:
lib.mkModule args "ioga.profiles.base" {
  options.enable = lib.mkBoolOpt' true; # enable by default
  config = { cfg }: {
    ioga.hardware = { networking.enable = true; };

    programs.dconf.enable = true;
  };
}
