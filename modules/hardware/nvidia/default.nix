{ options, config, lib, pkgs, ... }:
with lib;
with lib.internal;
let
  cfg = config.hardware.nvidia;
in
{
  options.hardware.nvidia = with types; {
    enable = mkBoolOpt false "Enable drivers and patches for Nvidia hardware.";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

    environment.variables = {
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };
    environment.shellAliases = { nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings"; };

    # Hyprland settings
    programs.hyprland.nvidiaPatches = true;
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
  };
}
