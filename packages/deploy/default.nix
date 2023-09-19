{
  writeShellScriptBin,
  glib,
  ...
}:
writeShellScriptBin "deploy" ''
  SYSTEMNAME=$1
  nixos-rebuild --target-host root@$SYSTEMNAME switch --flake .#$SYSTEMNAME
''
