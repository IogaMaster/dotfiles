{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.apps.tools.git" {
  config =
    { cfg }:
    {
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
      home = {
        configFiles."git/config".text = import ./_config.nix {
          sshKeyPath = "/home/${config.user.name}/.ssh/key.pub";
        };
        configFiles."lazygit/config.yml".source = ./lazygitConfig.yml;
        persist.directories = [
          ".config/gh"
          ".config/lazygit"
          ".config/systemd" # For git maintainance
        ];
      };
    };
}
