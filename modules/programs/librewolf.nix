{
  delib,
  inputs,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.librewolf";

  options = delib.singleEnableOption host.isDesktop;

  myconfig.ifEnabled = {
    persist.user.directories = [
      ".librewolf"
      ".cache/librewolf"
    ];
  };

  home.ifEnabled = {
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
    };
  };
}
