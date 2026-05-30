{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.hardware.bluetooth" {
  config =
    { cfg }:
    {
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
      environment.systemPackages = with pkgs; [ bluetuith ];
    };
}
