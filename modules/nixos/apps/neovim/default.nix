{
  inputs,
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.neovim;
  inherit (inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme}) colors;
in {
  options.apps.neovim = with types; {
    enable = mkBoolOpt false "Enable or disable neovim";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      EDITOR = "nvim";
    };
    environment.systemPackages = [
      pkgs.neovim

      pkgs.lazygit
      pkgs.stylua
      pkgs.sumneko-lua-language-server
      pkgs.ripgrep
    ];

    home.persist.directories = [
      ".local/share/nvim"
      ".vim"
      ".wakatime"
      ".nvim"
    ];

    home.configFile."base16.lua".text = ''
      return {
        base00 = "#${colors.base00}",
        base01 = "#${colors.base01}",
        base02 = "#${colors.base02}",
        base03 = "#${colors.base03}",
        base04 = "#${colors.base04}",
        base05 = "#${colors.base05}",
        base06 = "#${colors.base06}",
        base07 = "#${colors.base07}",
        base08 = "#${colors.base08}",
        base09 = "#${colors.base09}",
        base0A = "#${colors.base0A}",
        base0B = "#${colors.base0B}",
        base0C = "#${colors.base0C}",
        base0D = "#${colors.base0D}",
        base0E = "#${colors.base0E}",
        base0F = "#${colors.base0F}",
      }
    '';

    home.persist.files = [".wakatime.cfg" ".wakatime.bdb"];
  };
}
