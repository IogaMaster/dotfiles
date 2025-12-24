{ lib, config, ... }@args:
lib.mkModule args "ioga.hardware.nvidia" {
  options = let
    hasNvidiaDevice = builtins.any (gpu: (gpu.vendor.hex or "") == "10de")
      (config.facter.report.hardware.graphics_card or [ ]);
  in with lib;
  with lib.types; {
    enabled = mkBoolOpt' hasNvidiaDevice; # auto enable if nvidia card present
  };

  config = { cfg }: {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = false;
    environment = {
      variables = { CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv"; };
      shellAliases = {
        nvidia-settings =
          "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
      };
      sessionVariables.WLR_NO_HARDWARE_CURSORS =
        "1"; # Fix cursor rendering issue on wlr nvidia.
    };
  };
}
