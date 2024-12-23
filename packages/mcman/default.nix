{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "mcman";
  version = "unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "ParadigmMC";
    repo = "mcman";
    rev = "20180f9690593e3ca4663cb4e2771a750757b6ca";
    hash = "sha256-OGIAlm0wvDWcheT6G/hoqTvgDOPUBQQd7LCHu1OQupM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mcapi-0.2.0" = "sha256-pJ6f26r/R9qBnbJJkDSzGi9N/BlD9seS9/vEwgSZ0I8=";
      "pathdiff-0.2.1" = "sha256-+X1afTOLIVk1AOopQwnjdobKw6P8BXEXkdZOieHW5Os=";
      "rpackwiz-0.1.0" = "sha256-pOotNPIZS/BXiJWZVECXzP1lkb/o9J1tu6G2OqyEnI8=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      bzip2
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Powerful Minecraft Server Manager CLI. Easily install jars (server, plugins & mods) and write config files. Docker and git support included";
    homepage = "https://github.com/ParadigmMC/mcman";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "mcman";
  };
}
