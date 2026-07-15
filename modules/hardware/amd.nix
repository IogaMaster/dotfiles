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
        # Fixed: Removed obsolete si/cik flags, added hardware recovery overrides
        kernelParams = [
          "amdgpu.gpu_recovery=1"
          "amdgpu.lockup_timeout=10000"
          "amdgpu.reset_method=1"
          "amdgpu.aspm=0"
          "pcie_aspm=off"
          "mce=off"
        ];
      };

      environment.systemPackages = with pkgs; [
        ## Tools ##
        mesa-demos
        vulkan-tools # Khronos official Vulkan Tools and Utilities
        clinfo # Print information about available OpenCL platforms and devices
        libva-utils # Collection of utilities and examples for VA-API
        ## Monitor ##
        lact # Linux GPU Configuration Tool for AMD and NVIDIA
        amdgpu_top # Tool to display AMDGPU usage
        nvtopPackages.amd # (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
      ];
      systemd.packages = with pkgs; [ lact ];
      systemd.services.lactd.wantedBy = [ "multi-user.target" ];

      # Fixed: Added to ensure XWayland hooks map correctly
      services.xserver.videoDrivers = [ "amdgpu" ];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
            mesa.drivers
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            mesa.drivers
            libva-vdpau-driver
            libvdpau-va-gl
          ];
        };
      };

      environment = {
        sessionVariables = {
          # 1. FORCE RADV: Force Mesa's open-source driver over AMDVLK for Proton gaming
          AMD_VULKAN_ICD = "RADV";

          # Fixed: Removed RADV_PERF_TEST = "gpl" to stop UE5 memory management loops
        };
      };
    };
}
