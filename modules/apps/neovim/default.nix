{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.internal;
let cfg = config.apps.neovim; in
{
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
  };
}

