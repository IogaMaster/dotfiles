{ delib, ... }:
delib.module {
  name = "constants";

  options.constants = with delib; {
    username = readOnly (strOption "iogamaster");
    userfullname = readOnly (strOption "IogaMaster");
    useremail = readOnly (strOption "iogamastercode@gmail.com");
  };

  myconfig.always =
    { cfg, ... }:
    {
      args.shared.constants = cfg;
    };
}
