{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.desktop.addons.mako;
  inherit (inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme})
    colors
    ;
in
{
  options.desktop.addons.mako = with types; {
    enable = mkBoolOpt false "Enable or disable mako";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
      libnotify
    ];

    home.configFile."mako/config" = {
      text = ''
        background-color=#${colors.base00}
        text-color=#${colors.base05}
        border-color=#${colors.base0D}
        progress-color=over #${colors.base02}

        [urgency=high]
        border-color=#${colors.base09}
      '';
      onChange = ''
        ${pkgs.busybox}/bin/pkill -SIGUSR2 mako
      '';
    };
  };
}
