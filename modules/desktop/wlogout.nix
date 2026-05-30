{
  lib,
  colors,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.desktop.wlogout" {
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [ wlogout ];
      home.configFiles."wlogout/style.css".text = ''
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

      home.configFiles."wlogout/layout".text = ''
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
