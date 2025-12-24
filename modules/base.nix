{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.base" {
  options = with lib; {
    enable = mkBoolOpt' true; # enable by default
  };

  config = { cfg }: {
    environment = {
      sessionVariables = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "$HOME";
      };
      variables = {
        # Make some programs "XDG" compliant.
        LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";
    console = { keyMap = lib.mkForce "us"; };

    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };
    environment.systemPackages = with pkgs; [ font-manager ];
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
    time.timeZone = lib.mkDefault "America/Denver";

    console.useXkbConfig = true;
    services.xserver = {
      layout = "us";
      xkbOptions = "caps:escape";
    };
  };
}
