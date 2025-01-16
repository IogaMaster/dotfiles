{
  delib,
  host,
  pkgs,
  constants,
  ...
}:
delib.module {
  name = "programs.steam";

  options = delib.singleEnableOption host.isDesktop;

  myconfig.ifEnabled.persist.user.directories = [
    ".steam"
    ".local/share/Steam"
  ];

  nixos.ifEnabled.environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${constants.username}/.steam/root/compatibilitytools.d";
  };

  home.ifEnabled.home.packages = [
    pkgs.steam
    pkgs.mangohud
    pkgs.protonup
  ];
}
