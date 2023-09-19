{ options, config, lib, pkgs, ... }:
with lib;
with lib.internal;
let
  cfg = config.apps.discord;
in
{
  options.apps.discord = with types; {
    enable = mkBoolOpt false "Enable discord";
  };

  config =
    let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        rev = "159aac939d8c18da2e184c6581f5e13896e11697";
        sha256 = "sha256-cWpog52Ft4hqGh8sMWhiLUQp/XXipOPnSTG6LwUAGGA=";
      };

      theme = "${catppuccin}/themes/mocha.theme.css";
    in
    mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.webcord.override {
          flags = [ "--add-css-theme=${theme}" ];
        })
      ];
    };
}
