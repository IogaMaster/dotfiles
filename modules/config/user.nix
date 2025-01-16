{
  delib,
  lib,
  decryptSecretFile,
  constants,
  ...
}:
delib.module {
  name = "user";

  nixos.always =
    let
      inherit (constants) username;
    in
    {
      imports = [ (lib.mkAliasOptionModule [ "user" ] [ "users" "users" username ]) ];

      users = {
        groups.${username} = { };

        users.${username} = {
          isNormalUser = true;
          initialPassword = "password";
          # hashedPasswordFile = decryptSecretFile "user/hashedPassword";
          extraGroups = [ "wheel" ];
        };
      };
    };
}
