{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-edit";
  version = "unstable-2024-07-22";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "flake-edit";
    rev = "b45c6611bc4546b623cc781e53051cbde61f8c79";
    hash = "sha256-LPxubqQiYZVHUPJhVQbU4Zp1XhIrWl09ZGWFBV6RjVU=";
  };

  cargoHash = "sha256-hw60w2bR4whoItI61sWaMW9dBx8pjBCa6l1ziFI6CLY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Edit your flake inputs with ease";
    homepage = "https://github.com/a-kenji/flake-edit";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "flake-edit";
  };
}
