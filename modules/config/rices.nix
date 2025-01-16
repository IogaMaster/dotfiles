{ delib, ... }:
delib.module {
  name = "rices";

  options =
    with delib;
    let
      rice = {
        options = riceSubmoduleOptions;
      };
    in
    {
      rice = riceOption rice;
      rices = ricesOption rice;
    };

  myconfig.always =
    { myconfig, ... }:
    {
      args.shared = {
        inherit (myconfig) rice rices;
      };
    };

  home.always =
    { myconfig, ... }:
    {
      assertions = delib.riceNamesAssertions myconfig.rices;
    };
}
