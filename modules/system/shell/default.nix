{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
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

    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    home.configFile."starship.toml".source = ./starship.toml;

    environment.shellAliases = {
      ls = "eza -la --icons --no-user --no-time --git -s type";
      cat = "bat";
      ".." = "cd ..";

      neofetch = "nitch";
    };

    # Actual Shell Configurations
    home.programs.fish = mkIf (cfg.shell == "fish") {
      enable = true;
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
          };
        }
      ];
      shellInit = ''
        ${mkIf apps.tools.direnv.enable ''
              set -x DIRENV_LOG_FORMAT ""
          direnv hook fish | source
        ''}

        function , --description 'add software to shell session'
              nix shell nixpkgs#$argv[1..-1]
        end
      '';
    };

    # Enable all if nushell
    home.programs.nushell = mkIf (cfg.shell == "nushell") {
      enable = true;
    };
    home.configFile."nushell/" = mkIf (cfg.shell == "nushell") {
        recursive = true;
        source = ./nushell;
    };
  };
}
