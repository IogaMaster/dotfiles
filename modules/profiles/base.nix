{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.profiles.base" {
  options.enable = lib.mkBoolOpt' true; # enable by default
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [ ioga.sys ];
      ioga = {
        services.ssh.enable = true;
        hardware = {
          networking.enable = true;
        };
        apps.neovim.enable = true;
      };
      user.enable = true;
      shell.enable = true;
      home.enable = true;

      programs.dconf.enable = true;
      documentation.enable = false; # pretty big, use the internet
    };
}
