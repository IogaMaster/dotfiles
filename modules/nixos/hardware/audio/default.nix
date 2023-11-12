{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.audio;
in {
  options.hardware.audio = with types; {
    enable = mkBoolOpt false "Enable pipewire";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    programs.noisetorch.enable = true;
  };
}
