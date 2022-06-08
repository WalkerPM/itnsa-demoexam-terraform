resource "vsphere_virtual_machine" "rtr-isp" {

  for_each = toset( ["ISP"] )
  folder = "${data.vsphere_folder.folder.path}"

  name             = "${each.key}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template-linux.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-linux.scsi_type}"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id   = "${data.vsphere_network.pg-left-i-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-linux.network_interface_types[0]}"
  }

  network_interface {
    network_id   = "${data.vsphere_network.pg-right-i-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-linux.network_interface_types[0]}"
  }

   network_interface {
    network_id   = "${data.vsphere_network.pg-isp-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-linux.network_interface_types[0]}"
  }


  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template-linux.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-linux.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-linux.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template-linux.id}"
  }
  cdrom {
    datastore_id = "${data.vsphere_datastore.iso-datastore.id}"
    path         = var.linux_iso_path
 }
 
}

resource "vsphere_virtual_machine" "cli-ISP" {

  for_each = toset( ["CLI"] )
  folder = "${data.vsphere_folder.folder.path}"

  name             = "${each.key}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template-win-cli.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-win-cli.scsi_type}"
  wait_for_guest_net_timeout = 0
  firmware = "efi"
  network_interface {
    network_id   = "${data.vsphere_network.pg-isp-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-win-cli.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template-win-cli.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-win-cli.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-win-cli.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template-win-cli.id}"
    customize {
      network_interface {
      }
      windows_options {
        computer_name  = "CHANGEME"
        workgroup      = "WORKGROUP"
        admin_password = "P@ssw0rd!"
        time_zone = "180"

      }
    }
  }
}