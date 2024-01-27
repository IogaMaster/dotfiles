{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.impermanence;
in {
  options.impermanence = with types; {
    enable = mkBoolOpt false "Enable impermanence";
    removeTmpFilesOlderThan = mkOpt int 14 "Number of days to keep old btrfs_tmp files";
  };

  options.environment = with types; {
    persist = mkOpt attrs {} "Files and directories to persist in the home";
  };

  config = {
    # This script does the actual wipe of the system
    # So if it doesn't run, the btrfs system effectively acts like a normal system
    boot.initrd.postDeviceCommands = mkIf cfg.enable (lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/pool/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${builtins.toString cfg.removeTmpFilesOlderThan}); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '');

    environment.persistence."/persist" = mkIf cfg.enable (mkAliasDefinitions options.environment.persist);
  };
}
