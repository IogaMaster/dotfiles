{ delib, ... }:
delib.module {
  name = "programs.git";

  options = with delib; {
    enable = boolOption true;
    enableLFS = boolOption true;
  };

  home.ifEnabled.programs.git =
    { myconfig, cfg, ... }:
    {
      enable = cfg.enable;
      lfs.enable = cfg.enableLFS;

      userName = myconfig.constants.username;
      userEmail = myconfig.constants.useremail;
    };
}
