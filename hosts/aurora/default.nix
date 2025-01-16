{ delib, ... }:
delib.host {
  name = "aurora";
  type = "desktop";
  rice = "catppuccin-mocha";

  myconfig.graphics.vendor = "nvidia";

}
