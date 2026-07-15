{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.hardware.audio" {
  config =
    { cfg }:
    {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        wireplumber.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
      programs.noisetorch.enable = true;
      environment.systemPackages = with pkgs; [ pavucontrol ];
    };
}
