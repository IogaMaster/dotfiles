{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.internal;
let cfg = config.apps.tools.git; in
{
  options.apps.tools.git = with types; {
    enable = mkBoolOpt false "Enable or disable git";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      git-remote-gcrypt

      lazygit
      commitizen
    ];

    home.configFile."git/config".source = ./config;
    home.configFile."lazygit/config.yml".source = ./lazygitConfig.yml;
  };
}

