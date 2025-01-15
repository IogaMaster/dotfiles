{ delib, ... }:
delib.module {
  name = "programs.hyprland";

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bind = [
      "$mod, q, killactive,"
      "CTRLALT, Delete, exit,"

      "$mod, Return, exec, foot" # your terminal
    ];
  };
}
