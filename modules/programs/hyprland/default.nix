{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland";

  options.programs.hyprland = with delib; {
    enable = boolOption host.isDesktop;
  };

  nixos.ifEnabled.programs.hyprland.enable = true;
  home.ifEnabled.wayland.windowManager.hyprland.enable = true;
}
