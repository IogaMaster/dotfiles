{
  writeShellScriptBin,
  nix-output-monitor,
  pkgs,
  ...
}:
let
  nom = "${nix-output-monitor}/bin/nom";
  flake-edit = "${pkgs.custom.flake-edit}/bin/flake-edit";
in
writeShellScriptBin "sys" ''

  cmd_rebuild() {
      echo "🔨 Building system configuration with $REBUILD_COMMAND"
      $REBUILD_COMMAND switch --flake .# --log-format internal-json -v |& ${nom} --json
  }

  cmd_test() {
      echo "🏗️ Building ephemeral system configuration with $REBUILD_COMMAND"
      $REBUILD_COMMAND test --fast --flake .# --log-format internal-json -v |& ${nom} --json
  }

  cmd_flake() {
    ${flake-edit} "$@"
  }

  cmd_clean() {
      echo "🗑️ Cleaning and optimizing the Nix store."
      nix store optimise --verbose &&
      nix store gc --verbose
  }

  cmd_usage() {
      cat <<-_EOF
  Usage:
      $PROGRAM rebuild
          Rebuild the system. (You must be in the system flake directory!)
          Must be run as root.
      $PROGRAM test
          Like rebuild but faster and not persistent.
      $PROGRAM update [input]
          Update all inputs or the input specified. (You must be in the system flake directory!)
          Must be run as root.
      $PROGRAM clean
          Garbage collect and optimise the Nix Store.
      $PROGRAM help
          Show this text.
  _EOF
  }


  if [[ "$OSTYPE" == "linux"* ]]; then
    REBUILD_COMMAND="nixos-rebuild"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    REBUILD_COMMAND=darwin-rebuild
  fi

  # Subcommand utils based on pass

  PROGRAM=sys
  COMMAND="$1"
  case "$1" in
      rebuild|r) shift;       cmd_rebuild ;;
      test|t) shift;          cmd_test ;;
      update|u) shift;        cmd_update ;;
      flake|f) shift;         cmd_flake "$@";;
      clean|c) shift;         cmd_clean ;;
      help|--help) shift;     cmd_usage "$@" ;;
      *)              echo "Unknown command: $@" ;;
  esac
  exit 0
''
