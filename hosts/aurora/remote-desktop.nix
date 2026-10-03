{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true; # IntelliJ IDEA
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    openFirewall = false;
  };

  # RDP only over Tailscale
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 3389 ];

  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    openjdk17
    maven
    gradle
    jetbrains.idea
    tmux
    htop
  ];

  users.users.coder = {
    isNormalUser = true;
    uid = 1001;
    description = "iPad Coder";
    extraGroups = [ "wheel" ]; # remove if RDP shouldn't be root
    # initialPassword = "changeme"; # xrdp logs in via PAM, so it needs one
  };
}
