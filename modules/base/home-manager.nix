{
  delib,
  isHomeManager,
  homeManagerUser,
  config,
  pkgs,
  ...
}:
delib.module {
  name = "home-manager";

  myconfig.always.args.shared.homeconfig =
    if isHomeManager then config else config.home-manager.users.${homeManagerUser};

  nixos.always = {
    environment.systemPackages = [ pkgs.home-manager ];
    home-manager = {
      backupFileExtension = "home_manager_backup";
    };
  };

  home.always =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username;
    in
    {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };
    };
}
