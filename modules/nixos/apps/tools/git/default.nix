{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.git;
in {
  options.apps.tools.git = with types; {
    enable = mkBoolOpt false "Enable or disable git";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      git-remote-gcrypt

      gh # GitHub cli

      lazygit
      commitizen
    ];

    environment.shellAliases = {
      # Git aliases
      ga = "git add .";
      gc = "git commit -m ";
      gp = "git push -u origin";

      g = "lazygit";
    };

    home.configFile."git/config".source = ./config;
    home.configFile."lazygit/config.yml".source = ./lazygitConfig.yml;
  };
}
