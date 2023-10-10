{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  gnumake,
  SDL2,
  xorg,
  ...
}:
stdenv.mkDerivation {
  name = "relive";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "76ff25ce5158784d12a96259c17034534814eebd";
    hash = "sha256-oA7zBWtWBXwfH+OzfFv0IeUqqO1HmQ+Q/dLMXi6k3z4=";

    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gnumake
  ];
  buildInputs = [
    SDL2
    xorg.libXext
  ];

  patches = [
    ./speedrun.patch
  ];

  configurePhase = ''
    mkdir build && cd build
    cmake -S .. -B .
  '';

  buildPhase = ''
    make -j$(nproc)
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./Source/relive/relive $out/bin/.
    #re
  '';
}
