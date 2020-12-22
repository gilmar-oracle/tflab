resource "oci_core_vcn" "vcn_prod" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "vcn-prod"
  dns_label      = "vcnprod"
}

resource "oci_core_subnet" "sn_app" {
  cidr_block        = var.subnet_app_cidr
  display_name      = "sn-app"
  dns_label         = "snapp"
  security_list_ids = [oci_core_security_list.sl_prod.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn_prod.id
  route_table_id    = oci_core_route_table.rt_pub_prod.id
  dhcp_options_id   = oci_core_vcn.vcn_prod.default_dhcp_options_id
}

resource "oci_core_subnet" "sn_db" {
  cidr_block        = var.subnet_db_cidr
  display_name      = "sn-db"
  dns_label         = "sndb"
  security_list_ids = [oci_core_security_list.sl_prod.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn_prod.id
  route_table_id    = oci_core_route_table.rt_priv_prod.id
  dhcp_options_id   = oci_core_vcn.vcn_prod.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "ig_prod" {
  compartment_id = var.compartment_ocid
  display_name   = "ig-prod"
  vcn_id         = oci_core_vcn.vcn_prod.id
}

resource "oci_core_nat_gateway" "ng_prod" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_prod.id
  display_name   = "ng-prod"
}

resource "oci_core_route_table" "rt_pub_prod" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_prod.id
  display_name   = "rt-pub-prod"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig_prod.id
  }
}

resource "oci_core_route_table" "rt_priv_prod" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_prod.id
  display_name   = "rt-priv-prod"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.ng_prod.id
  }
}

resource "oci_core_security_list" "sl_prod" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_prod.id
  display_name   = "sl-prod"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3000"
      min = "3000"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3005"
      min = "3005"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }
}

resource "oci_core_security_list" "sl_prod_db" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn_prod.id
  display_name   = "sl_prod-db"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.vcn_cidr

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.subnet_app_cidr

    tcp_options {
      max = "1526"
      min = "1525"
    }
  }
}