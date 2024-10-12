{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "decoder";
  version = "unstable-2023-04-13";

  src = fetchFromGitHub {
    owner = "asheiduk";
    repo = "factorio-blueprint-decoder";
    rev = "d6cd1562f52e715721ce448be977e2d4fc71600a";
    hash = "sha256-S6IWVLmNJZEUJ2KWEbMD5VR3Gt5A8COUF8g6jz3+chY=";
  };

  meta = {
    description = "Decode Factorio's binary `blueprint-storage.dat` file into JSON for backup, downgrading or further manipulation";
    homepage = "https://github.com/asheiduk/factorio-blueprint-decoder";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [iogamaster];
    mainProgram = "decoder";
    platforms = lib.platforms.all;
  };
}
