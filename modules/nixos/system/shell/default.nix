{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.shell;
in {
  options.system.shell = with types; {
    shell = mkOpt (enum ["nushell" "fish"]) "nushell" "What shell to use";
  };

  config = {
    environment.systemPackages = with pkgs; [
      eza
      bat
      nitch
      zoxide
      starship
    ];

    users.defaultUserShell = pkgs.${cfg.shell};
    users.users.root.shell = pkgs.bashInteractive;

    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    home.configFile."starship.toml".source = ./starship.toml;

    environment.shellAliases = {
      ".." = "cd ..";
      neofetch = "nitch";
    };

    home.programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    # Actual Shell Configurations
    home.programs.fish = mkIf (cfg.shell == "fish") {
      enable = true;
      shellAliases = {
        ls = "eza -la --icons --no-user --no-time --git -s type";
        cat = "bat";
      };
      shellInit = ''
        ${mkIf apps.tools.direnv.enable ''
          direnv hook fish | source
        ''}

        zoxide init fish | source

        function , --description 'add software to shell session'
              nix shell nixpkgs#$argv[1..-1]
        end
      '';
    };

    # Enable all if nushell
    home.programs.nushell = mkIf (cfg.shell == "nushell") {
      enable = true;
      shellAliases = config.environment.shellAliases // {ls = "ls";};
      envFile.text = "";
      extraConfig = ''
        $env.config = {
        	show_banner: false,
        }

        def , [...packages] {
            nix shell ($packages | each {|s| $"nixpkgs#($s)"})
        }
      '';
    };
  };
}
