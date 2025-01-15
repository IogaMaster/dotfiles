{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ssh";

  options = delib.singleEnableOption true;

  myconfig.ifEnabled.persist.user.files = [
    ".ssh/key"
    ".ssh/key.pub"
    ".ssh/known_hosts"
  ];

  home.ifEnabled.programs.ssh = {
    enable = true;

    package = pkgs.openssh_hpn;
    compression = true;
    hashKnownHosts = true;
  };
}
