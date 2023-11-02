{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.development;
in {
  options.suites.development = with types; {
    enable = mkBoolOpt false "Enable the development suite";
  };

  config = mkIf cfg.enable {
    apps.neovim.enable = true;
    apps.tools.direnv.enable = true;

    apps.misc.enable = true;

    home.configFile."nix-init/config.toml".text = ''
      maintainers = ["iogamaster"]
      commit = true
    '';

    environment.systemPackages = with pkgs; [
      licensor

      # Nix Utils
      nix-index
      nix-init
      nix-melt
      nix-update
      nixpkgs-fmt
      nixpkgs-hammering
      nixpkgs-review
      nurl
    ];
  };
}
