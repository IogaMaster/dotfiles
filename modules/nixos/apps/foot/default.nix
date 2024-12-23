{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.apps.foot;
  inherit (inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme})
    colors
    ;
in
{
  options.apps.foot = with types; {
    enable = mkBoolOpt false "Enable or disable the foot terminal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.foot ];

    home.configFile."foot/foot.ini".text = ''
      font=JetBrains Mono Nerd Font:size=12
      pad=5x5
      [colors]
      foreground=${colors.base05}
      background=${colors.base00}
      regular0=${colors.base03}
      regular1=${colors.base08}
      regular2=${colors.base0B}
      regular3=${colors.base0A}
      regular4=${colors.base0D}
      regular5=${colors.base0F}
      regular6=${colors.base0C}
      regular7=${colors.base05}
      bright0=${colors.base04}
      bright1=${colors.base08}
      bright2=${colors.base0B}
      bright3=${colors.base0A}
      bright4=${colors.base0D}
      bright5=${colors.base0F}
      bright6=${colors.base0C}
      bright7=${colors.base05}
    '';
  };
}
