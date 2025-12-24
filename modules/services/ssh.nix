{ lib, colors, pkgs, ... }@args:
lib.mkModule args "ioga.services.ssh" {
  options.enable = lib.mkBoolOpt' true; # enabled by default
  config = { cfg }: {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "no";
    };
    environment.systemPackages = with pkgs; [ sshfs ];
    users.users = let
      key =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL9nKsW0v9SMQo86fxHlX5gnS/ELlWqAS/heyzZ+oPzd iogamastercode@gmail.com";
    in {
      iogamaster.openssh.authorizedKeys.keys = [ key ];
      root.openssh.authorizedKeys.keys = [ key ];
    };
  };
}
