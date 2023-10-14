{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  electron_25,
}:
stdenv.mkDerivation rec {
  pname = "blockbench";
  version = "4.8.3";

  src = fetchurl {
    url = "https://github.com/JannisX11/blockbench/releases/download/v${version}/Blockbench_${version}.AppImage";
    sha256 = "sha256-zKl+XM7f5wFYSS4vGgjUUehzxLMGAmk/gP9FzBfjN6A=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/blockbench.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_25}/bin/electron $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [stdenv.cc.cc]}"
    # hehe
  '';
}
