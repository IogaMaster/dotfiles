{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.waybar;
  colors = inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme}.colors;
in {
  options.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Enable or disable waybar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.waybar
    ];

    home.configFile."waybar/config.jsonc" = {
      source = ./config.jsonc;
      onChange = ''
        ${pkgs.busybox}/bin/pkill -SIGUSR2 waybar
      '';
    };
    home.configFile."waybar/style.css" = {
      text = ''
        * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: JetBrainsMono Nerd Font;
          font-size: 13px;
          border-radius: 17px;
        }

        #clock,
        #custom-notification,
        #custom-launcher,
        #custom-power-menu,
        /*#custom-colorpicker,*/
        #custom-window,
        #memory,
        #disk,
        #network,
        #battery,
        #custom-spotify,
        #pulseaudio,
        #window,
        #tray {
          padding: 5 15px;
          border-radius: 12px;
          background: #${colors.base00};
          color: #${colors.base07};
          margin-top: 8px;
          margin-bottom: 8px;
          margin-right: 2px;
          margin-left: 2px;
          transition: all 0.3s ease;
        }

        #window {
          background-color: transparent;
          box-shadow: none;
        }

        window#waybar {
          background-color: rgba(0, 0, 0, 0.096);
          border-radius: 17px;
        }

        window * {
          background-color: transparent;
          border-radius: 17px;
        }

        #workspaces button label {
          color: #${colors.base07};
        }

        #workspaces button.active label {
          color: #${colors.base00};
          font-weight: bolder;
        }

        #workspaces button:hover {
          box-shadow: #${colors.base07} 0 0 0 1.5px;
          background-color: #${colors.base00};
          min-width: 50px;
        }

        #workspaces {
          background-color: transparent;
          border-radius: 17px;
          padding: 5 0px;
          margin-top: 3px;
          margin-bottom: 3px;
        }

        #workspaces button {
          background-color: #${colors.base00};
          border-radius: 12px;
          margin-left: 10px;

          transition: all 0.3s ease;
        }

        #workspaces button.active {
          min-width: 50px;
          box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
          background-color: #${colors.base0F};
          background-size: 400% 400%;
          transition: all 0.3s ease;
          background: linear-gradient(
            58deg,
            #${colors.base0E},
            #${colors.base0E},
            #${colors.base0E},
            #${colors.base0D},
            #${colors.base0D},
            #${colors.base0E},
            #${colors.base08}
          );
          background-size: 300% 300%;
          animation: colored-gradient 20s ease infinite;
        }

        @keyframes colored-gradient {
          0% {
            background-position: 71% 0%;
          }
          50% {
            background-position: 30% 100%;
          }
          100% {
            background-position: 71% 0%;
          }
        }

        #custom-power-menu {
          margin-right: 10px;
          padding-left: 12px;
          padding-right: 15px;
          padding-top: 3px;
        }

        #custom-spotify {
          margin-left: 5px;
          padding-left: 15px;
          padding-right: 15px;
          padding-top: 3px;
          color: #${colors.base07};
          background-color: #${colors.base00};
          transition: all 0.3s ease;
        }

        #custom-spotify.playing {
          color: rgb(180, 190, 254);
          background: rgba(30, 30, 46, 0.6);
          background: linear-gradient(
            90deg,
            #${colors.base02},
            #${colors.base00},
            #${colors.base00},
            #${colors.base00},
            #${colors.base00},
            #${colors.base02}
          );
          background-size: 400% 100%;
          animation: grey-gradient 3s linear infinite;
          transition: all 0.3s ease;
        }

        @keyframes grey-gradient {
          0% {
            background-position: 100% 50%;
          }
          100% {
            background-position: -33% 50%;
          }
        }

        #tray menu {
          background-color: #${colors.base00};
          opacity: 0.8;
        }

        #pulseaudio.muted {
          color: #${colors.base08};
          padding-right: 16px;
        }

        #custom-notification.collapsed,
        #custom-notification.waiting_done {
          min-width: 12px;
          padding-right: 17px;
        }

        #custom-notification.waiting_start,
        #custom-notification.expanded {
          background-color: transparent;
          background: linear-gradient(
            90deg,
            #${colors.base02},
            #${colors.base00},
            #${colors.base00},
            #${colors.base00},
            #${colors.base00},
            #${colors.base02}
          );
          background-size: 400% 100%;
          animation: grey-gradient 3s linear infinite;
          min-width: 500px;
          border-radius: 17px;
        }
      '';
      onChange = ''
        ${pkgs.busybox}/bin/pkill -SIGUSR2 waybar
      '';
    };
  };
}
