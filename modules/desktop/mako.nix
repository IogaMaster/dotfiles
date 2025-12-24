{ lib, colors, pkgs, ... }@args:
lib.mkModule args "ioga.desktop.mako" {
  config = { cfg }: {
    environment.systemPackages = with pkgs; [ mako libnotify ];
    home.configFiles."mako/config" = {
      text = ''
        background-color=#${colors.base00}
        text-color=#${colors.base05}
        border-color=#${colors.base0D}
        progress-color=over #${colors.base02}
        [urgency=high]
        border-color=#${colors.base09}
      '';
    };
  };
}
