
resource "vsphere_virtual_machine" "websrv-right" {

  for_each = toset( ["WEB-R"] )
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
    network_id   = "${data.vsphere_network.pg-right-g-uid.id}"
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
}

resource "vsphere_virtual_machine" "rtr-right" {

  for_each = toset( ["RTR-R"] )
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
    network_id   = "${data.vsphere_network.pg-right-i-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-rtr.network_interface_types[0]}"
  }

  network_interface {
    network_id   = "${data.vsphere_network.pg-right-g-uid.id}"
    adapter_type = "${data.vsphere_virtual_machine.template-rtr.network_interface_types[0]}"
  }



  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template-rtr.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-rtr.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-rtr.disks.0.thin_provisioned}"
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.iso-datastore.id}"
    path         = "csr1000v-universalk9.16.09.04.iso"
  }
}
