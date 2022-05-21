
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}

variable "lab-name" { 
   type = string 
   default = "Lab-1"
   }

provider "vsphere" {
  user           = "administrator@lab.lan"
  password       = "(mT4bNdRwT"
  vsphere_server = "192.168.15.58"

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "DC1"
}

data "vsphere_host" "host" {
  name          = "192.168.15.34"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_folder" "folder" {
  path = "Lab1"
}



data "vsphere_datastore" "datastore" {
  name          = "Dick-SSD"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_datastore" "iso-datastore" {
  name          = "datastore1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "Competitor 1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template-linux" {
  name          = "Debian 11"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template-web" {
  name          = "Linux Web RC2021"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template-rtr" {
  name          = "CSR1000v 9.17"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template-win-srv" {
  name          = "Windows Server 2019 STD GUI"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_virtual_machine" "template-win-cli" {
  name          = "Windows 10 Enterprise x64"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}