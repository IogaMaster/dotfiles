{ config, pkgs, ... }:

{
  # --- DECLARATIVE JAVA DEV CONTAINER ---
  containers.school-sandbox = {
    autoStart = true;
    privateNetwork = false; # Inherits the host network to seamlessly bind to Tailscale

    # Impermanence Integration: Persists your IDE settings and class projects
    bindMounts = {
      "/home/coder" = {
        hostPath = "/persist/home/coder";
        isReadOnly = false;
      };
    };

    config =
      { config, pkgs, ... }:
      {
        system.stateVersion = "26.05";

        # Required for IntelliJ IDEA
        nixpkgs.config.allowUnfree = true;

        # XFCE Desktop System Services
        services.xserver = {
          enable = true;
          desktopManager.xfce.enable = true;
        };

        # XRDP Server mapped to XFCE
        services.xrdp = {
          enable = true;
          openFirewall = true;
          defaultWindowManager = "xfce4-session";
        };

        # Developer Tools
        programs.git.enable = true;
        environment.systemPackages = with pkgs; [
          openjdk17 # Swap to openjdk21 if needed for your syllabus
          maven
          gradle
          jetbrains.idea # Updated package target for the unified distribution
          tmux
          htop
        ];

        # Container User
        users.users.coder = {
          isNormalUser = true;
          uid = 1001; # Constant UID to match host-level permissions
          description = "iPad Coder";
          extraGroups = [ "wheel" ];
        };
      };
  };
}
