{
  lib,
  inputs,
  options,
  ...
}@args:
(lib.mkModule args "impermanence" {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  options =
    with lib;
    with lib.types;
    {
      removeTmpFilesOlderThan = mkOpt int 14 "Number of days to keep old btrfs_tmp files";
    };
  rawOptions = {
    environment =
      with lib;
      with lib.types;
      {
        persist = mkOpt attrs { } "Files and directories to persist";
      };
  };
  config =
    { cfg }:
    {
      # This script does the actual wipe of the system
      # So if it doesn't run, the btrfs system effectively acts like a normal system
      # boot.initrd.postDeviceCommands = lib.mkAfter ''
      #   mkdir /btrfs_tmp
      #   mount /dev/pool/root /btrfs_tmp
      #   if [[ -e /btrfs_tmp/root ]]; then
      #       mkdir -p /btrfs_tmp/old_roots
      #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      #       mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      #   fi
      #
      #   delete_subvolume_recursively() {
      #       IFS=$'\n'
      #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
      #           delete_subvolume_recursively "/btrfs_tmp/$i"
      #       done
      #       btrfs subvolume delete "$1"
      #   }
      #
      #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${builtins.toString cfg.removeTmpFilesOlderThan}); do
      #       delete_subvolume_recursively "$i"
      #   done
      #
      #   btrfs subvolume create /btrfs_tmp/root
      #   umount /btrfs_tmp
      # '';

      environment.persistence."/persist" = lib.mkAliasDefinitions options.environment.persist;
      environment.persist.directories = [ "/var/lib/nixos" ];
      fileSystems."/persist".neededForBoot = true;
    };
})
