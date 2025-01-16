{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "localization";

  options.localization = with delib; {
    enable = boolOption host.isDesktop;

    timeZone = strOption "America/Denver";
    locale = strOption "en_US.UTF-8";
  };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      time.timeZone = cfg.timeZone;
      environment.variables.TZ = cfg.timeZone;
      i18n.defaultLocale = cfg.locale;
      console.keyMap = lib.mkForce "us";
    };
}
