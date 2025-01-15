{ delib, ... }:
delib.module {
  name = "args";

  options.args = with delib; {
    shared = attrsLegacyOption { };
    nixos = attrsLegacyOption { };
    home = attrsLegacyOption { };
  };

  nixos.always =
    { cfg, ... }:
    {
      _module.args = cfg.shared // cfg.nixos;
    };
  home.always =
    { cfg, ... }:
    {
      _module.args = cfg.shared // cfg.home;
    };
}
