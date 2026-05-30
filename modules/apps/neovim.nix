{
  lib,
  colors,
  pkgs,

  inputs,
  ...
}@args:
lib.mkModule args "ioga.apps.neovim" {
  config =
    { cfg }:
    {
      nixpkgs.overlays = [
        inputs.neovim.overlays.default
      ];
      environment.systemPackages = with pkgs; [
        neovim

        pkgs.lazygit
        pkgs.ripgrep
      ];

      home.persist.directories = [
        ".nvim"
        ".local/share/nvim"
      ];
    };
}
