{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.apps.pass;
in
{
  options.apps.pass = with types; {
    enable = mkBoolOpt false "Enable or disable pass";
  };

  config = mkIf cfg.enable {
    apps.tools.gnupg.enable = true;

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "pass" ''
        GNUPGHOME="$XDG_DATA_HOME/gnupg" PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass" ${
          pkgs.pass.withExtensions (exts: [
            exts.pass-otp
            exts.pass-update
            exts.pass-audit
          ])
        }/bin/pass $@
      '')
    ];

    home.persist.directories = [ ".local/share/pass" ];
  };
}
