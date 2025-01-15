{ delib, ... }:
delib.module {
  name = "programs.hyprland";

  options = { myconfig, ... }@args: delib.singleEnableOption myconfig.host.isDesktop args;

  # nixos.ifEnabled.programs.hyprland.enable = true;
  home.ifEnabled.wayland.windowManager.hyprland.enable = true;
}
