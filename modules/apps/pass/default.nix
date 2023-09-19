{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.internal;
let cfg = config.apps.pass; in
{
  options.apps.pass = with types; {
    enable = mkBoolOpt false "Enable or disable pass";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (pass.withExtensions (exts: [ exts.pass-otp ]))
    ];
    environment.variables.PASSWORD_STORE_DIR = "$XDG_DATA_HOME/pass";
  };
}

