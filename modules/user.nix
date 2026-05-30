{ lib, ... }@args:
lib.mkModule args "user" {
  options =
    with lib;
    with lib.types;
    {
      name = mkOpt' str "iogamaster";
      extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
      extraOptions = mkOpt attrs { } "Extra options passed to <option>users.users.<name></option>.";
    };
  config =
    { cfg }:
    {
      home.persist.directories = [
        "Documents"
        "Music"
        "Pictures"
        "dev"

        ".dotfiles"
      ];
      users.mutableUsers = false;
      users.users.${cfg.name} = {
        inherit (cfg) name;
        isNormalUser = true;
        home = "/home/${cfg.name}";
        group = "users";
        extraGroups = [
          "wheel"
          "audio"
          "sound"
          "video"
          "networkmanager"
          "input"
          "tty"
        ]
        ++ cfg.extraGroups;
        initialPassword = "password";
      }
      // cfg.extraOptions;
      security.sudo.wheelNeedsPassword = false;
    };
}
