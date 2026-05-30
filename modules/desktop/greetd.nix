{
  lib,
  colors,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.desktop.greetd" {
  config =
    { cfg }:
    {
      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "start-hyprland";
            user = "iogamaster";
          };
          default_session = initial_session;
        };
      };

    };
}
