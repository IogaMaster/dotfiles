{ lib, colors, pkgs, ... }@args:
lib.mkModule args "ioga.desktop.gtklock" {
  config = { cfg }: {
    environment.systemPackages = with pkgs; [ gtklock ];
    security.pam.services.gtklock = { };
    home.configFiles."gtklock/style.css".text = ''
      window {
         background-size: cover;
         background-repeat: no-repeat;
         background-position: center;
         background-color: #${colors.base00};
      }

      clock-label {
          color: #${colors.base05};
      }
    '';
  };
}
