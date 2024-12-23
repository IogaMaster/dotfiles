{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    treefmt

    nixfmt-rfc-style
    python310Packages.mdformat
    shfmt
  ];
}
