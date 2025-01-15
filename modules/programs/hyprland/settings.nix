{ delib, ... }:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    general = {
      gaps_in = 5;
      gaps_out = 10;
    };
  };
}
