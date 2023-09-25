{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.suites.common;
in {
  options.suites.common = with types; {
    enable = mkBoolOpt false "Enable the common suite";
  };

  config = mkIf cfg.enable {
    system.nix.enable = true;
    system.security.doas.enable = true;

    hardware.audio.enable = true;
    hardware.networking.enable = true;

    apps.misc.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
      General = {
        FastConnectable = true;
        JustWorksRepairing = "always";
        Privacy = "device";
      };
      Policy = {
        AutoEnable = true;
      };
    };

    apps.pass.enable = true;
    apps.tools.git.enable = true;
    apps.tools.nix-ld.enable = true;

    services.ssh.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = [pkgs.bluetuith pkgs.custom.sys pkgs.custom.deploy];

    system = {
      fonts.enable = true;
      locale.enable = true;
      time.enable = true;
      xkb.enable = true;
    };
  };
}
