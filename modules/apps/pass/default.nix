{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.apps.pass" {
  options.enable = lib.mkBoolOpt' true; # enable by default
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [
        gopass
        gopass-hibp
        gopass-jsonapi
        git-credential-gopass
      ];

      environment.shellAliases.pass = "gopass";

      home.configFiles."gopass/config".source = ./config.ini;
      home.persist.directories = [ ".local/share/gopass" ];
    };
}
