{
  options,
  config,
  pkgs,
  lib,
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

    home.configFile."git/config".text = import ./config.nix {sshKeyPath = "/home/${config.user.name}/.ssh/key.pub";};
    home.configFile."lazygit/config.yml".source = ./lazygitConfig.yml;

    home.persist.directories = [
      ".config/gh"
      ".config/lazygit"
      ".config/systemd" # For git maintainance
    ];
  };
}
