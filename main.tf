locals {
  host_files = fileset(".", "hosts/**/host.tf.json")
  all_hosts  = { for f in local.host_files : f => jsondecode(file(f)) }

  vultr_hosts = {
    for f, content in local.all_hosts : f => content
    if lookup(content, "provider", "") == "vultr"
  }
}


resource "vultr_instance" "vps" {
  for_each = local.vultr_hosts

  label  = each.value.hostname
  region = "lax"
  plan   = "vc2-1c-1gb"
  os_id  = "1743"

  ssh_key_ids = [vultr_ssh_key.main.id]
}

module "deploy" {
  source                 = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  for_each               = local.all_hosts
  target_host            = lookup(each.value, "provider", "") == "vultr" ? vultr_instance.vps[each.key].main_ip : each.value.ipv4
  instance_id            = lookup(each.value, "provider", "") == "vultr" ? vultr_instance.vps[each.key].id : each.value.ipv4
  nixos_system_attr      = ".#nixosConfigurations.${each.value.hostname}.config.system.build.toplevel"
  nixos_partitioner_attr = ".#nixosConfigurations.${each.value.hostname}.config.system.build.diskoScript"
  nixos_facter_path      = format("%s/facter.json", trimsuffix(each.key, "host.tf.json"))

  nix_options = {
    "min-free" = "0"
    "max-free" = "0"
  }

  install_user = "root"
  target_user  = "iogamaster"
}

output "instance_ips" {
  value = { for k, v in vultr_instance.vps : k => v.main_ip }
}
