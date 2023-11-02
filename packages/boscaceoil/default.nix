{
  stdenv,
  fetchurl,
  makeWrapper,
  unzip,
  wine,
}:
stdenv.mkDerivation rec {
  pname = "boscaceoil";
  version = "2.0";

  src = fetchurl {
    url = "http://www.boscaceoil.net/downloads/boscaceoil_win_v2.zip";
    sha256 = "sha256-jUnKsDFGH+aB9qqjp0FbqsJ8pTzInSPFhXJFlYPu9V0=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeWrapper unzip];

  unpackPhase = ''
    mkdir $out
    unzip $src -d $out
  '';

  installPhase = ''
    makeWrapper ${wine}/bin/wine $out/bin/${pname} \
      --add-flags $out/BoscaCeoil.exe \
  '';
}
