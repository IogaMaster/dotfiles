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
      ports = [22];

      passwordAuthentication = false;
    };

    users.users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9nKsW0v9SMQo86fxHlX5gnS/ELlWqAS/heyzZ+oPzd iogamastercode@gmail.com"
      ];
      ${config.user.name}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9nKsW0v9SMQo86fxHlX5gnS/ELlWqAS/heyzZ+oPzd iogamastercode@gmail.com"
      ];
    };

    home.file.".ssh/config".text = ''
      identityfile ~/.ssh/key
    '';

    home.persist.directories = [
      ".ssh"
    ];

    environment.persist.directories = [
      "/root/ssh"
    ];

    environment.persist.files = [
      "/etc/machine-id"
    ];
  };
}
