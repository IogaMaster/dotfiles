{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.pass;
in {
  options.apps.pass = with types; {
    enable = mkBoolOpt false "Enable or disable pass";
  };

  config = mkIf cfg.enable {
    home.programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    };
    # environment.systemPackages = with pkgs; [
    #   (pass.withExtensions (exts: [exts.pass-otp]))
    # ];
    # environment.variables.PASSWORD_STORE_DIR = "$XDG_DATA_HOME/pass";
  };
}
