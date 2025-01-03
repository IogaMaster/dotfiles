{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.apps.tools.gnupg;
in
{
  options.apps.tools.gnupg = with types; {
    enable = mkBoolOpt false "Enable gnupg";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.pinentry
      pkgs.pinentry-curses

      (pkgs.writeShellScriptBin "gpg" ''
        GNUPGHOME=${config.environment.variables.GNUPGHOME} ${pkgs.gnupg}/bin/gpg $@
      '')
    ];

    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };

    home.file.".local/share/gnupg/gpg-agent.conf".source = ./gpg-agent.conf;

    environment.variables = {
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    };

    home.persist.directories = [
      ".local/share/gnupg"
      ".pki"
    ];
  };
}
