{ lib, inputs, options, config, ... }@args:
lib.mkModule args "home" {
  imports = [ inputs.hjem.nixosModules.default ];
  options = with lib;
    with lib.types; {
      files = mkOpt' attrs { };
      configFiles = mkOpt' attrs { };
      persist = mkOpt attrs { } "Files and directories to persist in the home";
      extraOptions = mkOpt attrs { } "Options to pass directly to hjem";
    };
  config = { cfg }:
    with lib;
    with lib.types; {
      hjem.users.${config.user.name} = {
        user = config.user.name;
        directory = "/home/${config.user.name}";
        clobberFiles = true;

        files = mkAliasDefinitions options.home.files;
        xdg.config.files = mkAliasDefinitions options.home.configFiles;
      } // cfg.extraOptions;

      environment.persistence."/persist".users.${config.user.name} =
        mkIf options.impermanence.enable.value
        (mkAliasDefinitions options.home.persist);
    };
}
