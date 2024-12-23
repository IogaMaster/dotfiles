{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.apps.misc;
in
{
  options.apps.misc = with types; {
    enable = mkBoolOpt false "Enable or disable misc apps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Development
      git
      git-remote-gcrypt
      bat
      eza
      fzf
      fd

      # Util
      unzip
      sshfs
      btop
      ffmpeg
      python3
      wl-clipboard

      obsidian
      pandoc
      bookworm

      kjv
    ];

    home.persist.directories = [ ".config/obsidian" ];
  };
}
