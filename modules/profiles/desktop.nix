{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.profiles.desktop" {
  config = { cfg }: {
    ioga = {
      desktop = {
        hyprland.enable = true;
        waybar.enable = true;

        swww.enable = true;
        gdm.enable = true;
        gtklock.enable = true;
        mako.enable = true;
        wlogout.enable = true;
        wofi.enable = true;
      };

      apps = {
        discord.enable = true;
        firefox.enable = true;
        foot.enable = true;
      };
      hardware = {
        audio.enable = true;
        graphics.enable = true;
      };
    };
  };
}
