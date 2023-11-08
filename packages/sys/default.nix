{writeShellScriptBin, ...}:
writeShellScriptBin "sys" ''

  cmd_rebuild() {
      echo "🔨 Building system configuration with $REBUILD_COMMAND"
      $REBUILD_COMMAND switch --flake .#
  }

  cmd_test() {
      echo "🏗️ Building ephemeral system configuration with $REBUILD_COMMAND"
      $REBUILD_COMMAND test --fast --flake .#
  }

  # TODO: Make it update a single input
  cmd_update() {
      echo "🔒Updating flake.lock"
      nix flake update
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
          Like rebuild but faster and not persistant.
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
    REBUILD_COMMAND=nixos-rebuild
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
      clean|c) shift;         cmd_clean ;;
      help|--help) shift;     cmd_usage "$@" ;;
      *)              echo "Unknown command: $@" ;;
  esac
  exit 0
''
