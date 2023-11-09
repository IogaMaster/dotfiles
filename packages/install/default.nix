{writeShellScriptBin, ...}:
writeShellScriptBin "install" ''
  nix run github:nix-community/nixos-anywhere -- --flake .#$1 root@$2
  deploy .#$1
''
