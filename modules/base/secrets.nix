# !!! BLACKMAGIC !!!
# Black magic is used in this file to read ~/.config/sops/age/keys.txt
{
  delib,
  homeconfig,
  ylib,
  pkgs,
  ...
}:
delib.module {
  name = "secrets";

  # options.sops = with delib; {
  #   secrets = attrsOfOption attrs {};
  #   templates = attrsOfOption attrs {};
  # };

  myconfig.always = {
    args.shared =
      let
        rootDecryptSecretFile =
          path: key:
          (ylib.sops-decrypt {
            privateKeysFile = "~/.config/sops/age/keys.txt";
            inherit path key;
          });
        rootDecryptSecret = path: key: builtins.readFile (rootDecryptSecretFile path key);
      in
      {
        decryptSecret = rootDecryptSecret ../../secrets.yaml;
        decryptHostSecret = hostName: rootDecryptSecret ../../hosts/${hostName}/secrets.yaml;
        decryptSecretFile = rootDecryptSecretFile ../../secrets.yaml;
        decryptHostSecretFile = hostName: rootDecryptSecretFile ../../hosts/${hostName}/secrets.yaml;
      };

    persist.user.files = [ ".config/sops/age/keys.txt" ];
  };

  # templates are not yet implemented in sops-nix for home-manager
  # home.always = {cfg, ...}: {
  #   imports = [inputs.sops.homeManagerModule];

  #   sops = {
  #     defaultSopsFile = ../../secrets.yaml;
  #     defaultSopsFormat = "yaml";
  #     age.keyFile = toString /${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt;
  #     inherit (cfg) secrets;
  #   };
  # };

  home.always.home.packages = [ pkgs.sops ];
}
