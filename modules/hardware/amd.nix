{
  lib,
  config,
  pkgs,
  ...
}@args:

lib.mkModule args "ioga.hardware.amd" {
  config =
    { cfg }:
    {
      boot = {
        initrd.kernelModules = [ "amdgpu" ];
        kernelParams = [
          "amdgpu.gpu_recovery=1"
          "amdgpu.lockup_timeout=10000"
          "amdgpu.reset_method=1"
          "amdgpu.aspm=0"
          "pcie_aspm=off"
          "mce=off"
          # Fix for CachyOS / RX 5700 XT stability:
          "amdgpu.runpm=0"
          "processor.max_cstate=1"
        ];
      };

      environment.systemPackages = with pkgs; [
        ## Tools ##
        mesa-demos
        vulkan-tools
        clinfo
        libva-utils
        ## Monitor ##
        lact
        amdgpu_top
        nvtopPackages.amd
      ];

      # Fixed LACT systemd activation for NixOS
      systemd.services.lactd = {
        description = "AMDGPU Control Daemon";
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.lact}/bin/lact daemon";
        };
      };

      services.xserver.videoDrivers = [ "amdgpu" ];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            # Stripped duplicate mesa.drivers
            mesa
            rocmPackages.clr.icd
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            mesa
            libva-vdpau-driver
            libvdpau-va-gl
          ];
        };
      };

      environment = {
        sessionVariables = {
          AMD_VULKAN_ICD = "RADV";
        };
      };
    };
}
