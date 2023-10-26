{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.desktop.addons.wlogout;
  colors = inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme}.colors;
in {
  options.desktop.addons.wlogout = with types; {
    enable = mkBoolOpt false "Enable or disable wlogout.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wlogout
    ];

    home.configFile."wlogout/style.css".text = ''
       * {
         all: unset;
         font-family: JetBrains Mono Nerd Font;
       }

       window {
         background-color: #${colors.base00};
       }

       button {
         color: #${colors.base01};
         font-size: 64px;
         background-color: rgba(0,0,0,0);
         outline-style: none;
         margin: 5px;
      }

       button:focus, button:active, button:hover {
         color: #${colors.base0D};
         transition: ease 0.4s;
       }
    '';

    home.configFile."wlogout/layout".text = ''
      {
        "label" : "lock",
        "action" : "gtklock",
        "text" : "󰌾",
        "keybind" : ""
      }
      {
        "label" : "logout",
        "action" : "loginctl terminate-user $USER",
        "text" : "󰗽",
        "keybind" : ""
      }
      {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "󰐥",
        "keybind" : ""
      }
      {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "󰑓",
        "keybind" : ""
      }
    '';
  };
}
