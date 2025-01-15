{ delib, ... }:
let
  shared.nixpkgs.config = {
    allowUnfree = true;
  };
  # TODO: /root/.config/nixpkgs/config.nix
  files."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';
  variables."NIXPKGS_ALLOW_UNFREE" = 1;
in
delib.module {
  name = "nixpkgs";

  nixos.always = shared // {
    environment.variables = variables;
  };
  home.always = shared // {
    xdg.configFile = files;
    home.sessionVariables = variables;
  };
}
