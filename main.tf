locals {
  host_files = fileset(".", "systems/**/**/host.terraform.json")
  hosts = {
    for file in local.host_files :
    file => jsondecode(file(file))
  }
}

module "deploy" {
  for_each                   = local.hosts
  source                     = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr          = ".#nixosConfigurations.${each.value.hostname}.config.system.build.toplevel"
  nixos_partitioner_attr     = ".#nixosConfigurations.${each.value.hostname}.config.system.build.diskoScript"
  target_host                = each.value.ipv4
  instance_id                = each.value.ipv4
  nixos_generate_config_path = format("%s/hardware-config.nix", trimsuffix(each.key, "host.terraform.json")) # Get the current directory of the host
}
