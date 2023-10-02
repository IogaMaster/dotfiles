{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  cmake,
  darwin,
  git,
  cudaPackages_12_2,
  gnused,
}:
buildGoModule rec {
  pname = "ollama";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-k/ZhGazUxkFBdZsSx0vzt9ijKBSPJbWZ3kuqRX4wL9c=";
    fetchSubmodules = true;
  };

  patches = [./no-submodule-update.patch];

  buildInputs =
    [
      cudaPackages_12_2.cudatoolkit
    ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks; [
      Accelerate
      MetalPerformanceShaders
      MetalKit
    ]);

  nativeBuildInputs = [cmake git];

  preBuild = ''
    CUDA_VERSION=$(${cudaPackages_12_2.cuda_nvcc}/bin/nvcc --version | ${gnused}/bin/sed -n 's/^.*release \([0-9]\+\)\.\([0-9]\+\).*$/\1/p') go generate ./...
  '';

  vendorHash = "sha256-fhlRMFVCqhkBfscmIhnMHOZPiUAg/FABI5Ab90dVxg4=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    maintainers = with maintainers; [dit7ya];
    platforms = platforms.unix;
  };
}
