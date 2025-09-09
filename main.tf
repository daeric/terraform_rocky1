data "nutanix_clusters_v2" "amd" {
  filter = "name eq 'AMD'"
}

data "nutanix_templates_v2" "rocky_template"{
    filter="startswith(templateName,'Rocky')"
    page=0
    limit=10
}

resource "nutanix_deploy_templates_v2" "vm_from_template" {
  ext_id            = data.nutanix_templates_v2.rocky_template.templates[0].ext_id
  cluster_reference = data.nutanix_clusters_v2.amd.cluster_entities[0].ext_id
  number_of_vms     = var.number_of_vms
  override_vm_config_map{
      name= "Rocky I"
      memory_size_bytes = 8589934592
      num_sockets=1
      num_cores_per_socket=2
      num_threads_per_core=1
    }
}

#uncomment and run after the initial apply
#resource "nutanix_virtual_machine_v2" "vm-import" {}

#execute this command
#terraform import nutanix_virtual_machine_v2.vm-import <UUID>
