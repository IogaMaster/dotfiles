{ lib, pkgs, ... }@args:
lib.mkModule args "shell" {
  config =
    { cfg }:
    with lib;
    with lib.types;
    {
      users.defaultUserShell = pkgs.bash; # Ba(sed)sh(ell)
      users.users.root.shell = pkgs.bash;

      home.configFiles."starship.toml".source = ./starship.toml;
      home.persist.directories = [ ".local/share/direnv" ];

      environment = {
        systemPackages = with pkgs; [
          eza
          bat
          starship

          # utils
          btop
          unzip
          fzf
          fd
        ];

        shellAliases = {
          ".." = "cd ..";
          "ls" = "eza --no-user --no-time --git -s type";
        };
        sessionVariables.DIRENV_LOG_FORMAT = "";
        interactiveShellInit = ''
            bind -x '"\e[27;5;13~": "$TERM &> /dev/null & disown"'
            bind -x '"\e[13;5~": "$TERM &> /dev/null & disown"'
        '';
      };

      programs = {
        zoxide = {
          enable = true;
          enableBashIntegration = true;
        };

        direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
          loadInNixShell = true;
        };

        bash.interactiveShellInit = ''
          eval "$(starship init bash)"

          # comma makes nix shell awesome
          ,() {
              NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_BROKEN=1 nix shell $(printf 'nixpkgs#%s ' "$@") --impure
          }
        '';
      };
    };
}
