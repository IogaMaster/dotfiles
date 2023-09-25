{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  name = "nufmt"; # Same that is in Cargo.toml

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "796ee834c1e31ead4c5479bf2827a4339c5d61d1";
    hash = "sha256-BwKLl8eMCrqVt9PA5SHAXxu3ypP2ePcSuljKL+wSkvw=";
  };

  cargoSha256 = "sha256-JL1Ot2ldvieRM/SNLCC2YZ5b2hD98GXp+H4T/OFuKfk=";

  meta = with lib; {
    description = "The nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = licenses.mit;
    maintainers = with maintainers; [iogamaster];
  };
}
