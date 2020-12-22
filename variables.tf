variable "tenancy_ocid" {
}

variable "region" {
}

variable "compartment_ocid" {

}

variable "ad_region_mapping" {
  type = map(string)

  default = {
    sa-saopaulo-1 = 1
    us-ashburn-1 = 3
  }
}

variable "images" {
  type = map(string)

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaapulaxjedwo2y3koeli6zq6evql6rropyxpni3wu44i2rbffgxgza"
    sa-saopaulo-1   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaal36ok742hrg6644fdace5q3n64fuqmja3wegk2dbwptjpuz4ncaq"
  }
}

variable "instance_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 2
}

variable "vcn_cidr" {
  default = "10.1.0.0/16"
}

variable "subnet_app_cidr" {
  default = "10.1.20.0/24"
}

variable "subnet_db_cidr" {
  default = "10.1.21.0/24"
}