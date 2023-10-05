{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.apps.tools.fish;
in {
  options.apps.tools.fish = with types; {
    enable = mkBoolOpt false "Enable fish";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.fish pkgs.eza pkgs.bat pkgs.lazygit pkgs.git pkgs.nitch pkgs.zoxide];

    home.programs.fish = {
      enable = true;
      shellAliases = {
        ls = "eza -la --icons --no-user --no-time --git -s type";
        cat = "bat";
        ".." = "cd ..";

        # Git aliases
        ga = "git add .";
        gc = "git commit -m ";
        gp = "git push -u origin";

        g = "lazygit";
        neofetch = "nitch";
      };

      shellInit = ''
        set -x DIRENV_LOG_FORMAT ""
        direnv hook fish | source

        zoxide init fish | source

        function , --description 'add software to shell session'
              nix shell nixpkgs#$argv[1..-1]
        end
      '';
    };
  };
}
