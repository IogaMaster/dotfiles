{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.ssh;
in {
  options.services.ssh = with types; {
    enable = mkBoolOpt false "Enable ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkForce "no";
      ports = [22];
    };

    home.file.".ssh/config".text = ''
      identityfile ~/.ssh/key
    '';
  };
}
