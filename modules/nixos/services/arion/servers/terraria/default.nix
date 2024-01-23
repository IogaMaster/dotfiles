{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.arion.terraria.vanilla;
in {
  options.services.arion.terraria.vanilla = with types; {
    enable = mkBoolOpt false "";
  };

  config = mkIf cfg.enable {
    virtualisation.arion.enable = true;
    virtualisation.arion.projects.terraria-vanilla.settings = {
      project.name = "vanilla";
      services.terraria.service = {
        image = "ryshe/terraria:latest";
        environment = {
          WORLD_FILENAME = "world.wld";
          CONFIGPATH = "config.json";
        };
        ports = [
          "7777:7777"
        ];
        volumes = [
          "/home/${config.user.name}/.local/share/terraria/vanilla/worlds/:/root/.local/share/Terraria/Worlds"
        ];
        # For the first run you will need to generate a new world with a size where: 1 = Small, 2=Medium, 3=Large
        command = [
          "-autocreate 2"
        ];
      };
      services.ngrok.service = {
        image = "ngrok/ngrok";
        environment.env_file = config.sops.secrets."ngrok/terraria".path;
        command = ["tcp" "terraria:7777"];
      };
    };

    home.persist.directories = [
      ".local/share/terraria"
    ];
  };
}
