resource "vsphere_host_virtual_switch" "sw-left" {
   
  name           = "${var.lab-name}-Left"
  host_system_id = "${data.vsphere_host.host.id}"

    network_adapters = []

    active_nics  = []
    standby_nics = []

}

resource "vsphere_host_virtual_switch" "sw-right" {
  name           = "${var.lab-name}-Right"
  host_system_id = "${data.vsphere_host.host.id}"

    network_adapters = []

    active_nics  = []
    standby_nics = []

}

resource "vsphere_host_virtual_switch" "sw-isp" {
  name           = "${var.lab-name}-ISP"
  host_system_id = "${data.vsphere_host.host.id}"

    network_adapters = []

    active_nics  = []
    standby_nics = []

}

resource "vsphere_host_port_group" "pg-isp" {
   
  name                = "${var.lab-name}-ISP"
  host_system_id      = "${data.vsphere_host.host.id}"
  virtual_switch_name = "${vsphere_host_virtual_switch.sw-isp.name}"
}

resource "vsphere_host_port_group" "pg-left-g" {
   
  name                = "${var.lab-name}-Left"
  host_system_id      = "${data.vsphere_host.host.id}"
  virtual_switch_name = "${vsphere_host_virtual_switch.sw-left.name}"
}
resource "vsphere_host_port_group" "pg-left-i" {
   
  name                = "${var.lab-name}-External-L"
  host_system_id      = "${data.vsphere_host.host.id}"
  virtual_switch_name = "${vsphere_host_virtual_switch.sw-left.name}"
}


resource "vsphere_host_port_group" "pg-right-g" {
   
  name                = "${var.lab-name}-Right"
  host_system_id      = "${data.vsphere_host.host.id}"
  virtual_switch_name = "${vsphere_host_virtual_switch.sw-right.name}"
}
resource "vsphere_host_port_group" "pg-right-i" {
   
  name                = "${var.lab-name}-External-R"
  host_system_id      = "${data.vsphere_host.host.id}"
  virtual_switch_name = "${vsphere_host_virtual_switch.sw-right.name}"
}



data "vsphere_network" "pg-left-g-uid" {
  name = "${var.lab-name}-Left"
  datacenter_id = data.vsphere_datacenter.dc.id

  depends_on    = [vsphere_host_port_group.pg-left-g]
}
data "vsphere_network" "pg-left-i-uid" {
  name = "${var.lab-name}-External-L"
  datacenter_id = data.vsphere_datacenter.dc.id

  depends_on    = [vsphere_host_port_group.pg-left-i]
}
data "vsphere_network" "pg-right-g-uid" {
  name = "${var.lab-name}-Right"
  datacenter_id = data.vsphere_datacenter.dc.id

  depends_on    = [vsphere_host_port_group.pg-right-g]
}
data "vsphere_network" "pg-right-i-uid" {
  name = "${var.lab-name}-External-R"
  datacenter_id = data.vsphere_datacenter.dc.id

  depends_on    = [vsphere_host_port_group.pg-left-i]
}

data "vsphere_network" "pg-isp-uid" {
  name = "${var.lab-name}-ISP"
  datacenter_id = data.vsphere_datacenter.dc.id

  depends_on    = [vsphere_host_port_group.pg-isp]
}

data "vsphere_network" "pg-internet-uid" {
  name = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
} //Порт-группа с интернетом, на всякий случай
