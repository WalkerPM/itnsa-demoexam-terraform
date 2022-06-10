
resource "vsphere_virtual_machine" "win-srv-left" {

  for_each = toset( ["SRV"] )
  folder = "${data.vsphere_folder.folder.path}"

  name             = "${each.key}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template-win-srv.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-win-srv.scsi_type}"
  wait_for_guest_net_timeout = 0
  firmware = "efi"
  network_interface {
    network_id   = "${data.vsphere_network.pg-left-g-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-win-srv.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template-win-srv.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-win-srv.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-win-srv.disks.0.thin_provisioned}"
  }
  disk {
    unit_number = 1
    label = "disk1"
    size = 2
  }
  disk {
    unit_number = 2
    label = "disk2"
    size = 2
  }
  cdrom {
    client_device = true
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template-win-srv.id}"
    customize {
      network_interface {
      }
      windows_options {
        computer_name  = "CHANGEME"
        workgroup      = "WORKGROUP"
        admin_password = "Passw0rd"
        time_zone = "180"

      }
    }
  }
}

resource "vsphere_virtual_machine" "websrv-left" {

  for_each = toset( ["WEB-L"] )
  folder = "${data.vsphere_folder.folder.path}"

  name             = "${each.key}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template-linux.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-linux.scsi_type}"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id   = "${data.vsphere_network.pg-left-g-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-linux.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template-linux.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-linux.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-linux.disks.0.thin_provisioned}"
  }
  cdrom {
    datastore_id = "${data.vsphere_datastore.iso-datastore.id}"
    path         =  var.linux_iso_path
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template-linux.id}"
  }
}

resource "vsphere_virtual_machine" "rtr-left" {

  for_each = toset( ["RTR-L"] )
  folder = "${data.vsphere_folder.folder.path}"

  name             = "${each.key}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template-rtr.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-rtr.scsi_type}"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id   = "${data.vsphere_network.pg-left-i-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-rtr.network_interface_types[0]}"
  }
  network_interface {
    network_id   = "${data.vsphere_network.pg-left-g-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-rtr.network_interface_types[0]}"
  }
  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template-rtr.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-rtr.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-rtr.disks.0.thin_provisioned}"
  }
}
