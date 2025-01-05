{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    treefmt

    nixfmt-rfc-style
    python310Packages.mdformat
    shfmt

    (terraform.withPlugins (
      p: with p; [
        p.null # If i don't use `p.` then nix thinks i mean a null literal
        external
      ]
    ))
    jq
  ];
}
