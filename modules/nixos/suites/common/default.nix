{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.suites.common;
in
{
  options.suites.common = with types; {
    enable = mkBoolOpt false "Enable the common suite";
  };

  config = mkIf cfg.enable {
    system.nix.enable = true;
    system.security.sudo.enable = true;

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
      inputs = {
        UserSpaceHID = true;
      };
    };

    environment.persist.directories = [ "/etc/bluetooth" ];

    apps.pass.enable = true;
    apps.tools.git.enable = true;
    apps.tools.nix-ld.enable = true;

    services.ssh.enable = true;

    programs.dconf.enable = true;

    environment.systemPackages = [
      pkgs.bluetuith
      pkgs.custom.sys
      pkgs.deploy-rs
    ];

    system = {
      fonts.enable = true;
      locale.enable = true;
      time.enable = true;
      xkb.enable = true;
    };
  };
}
