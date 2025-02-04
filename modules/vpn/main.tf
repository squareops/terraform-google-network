module "service_accounts_vpn" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.0"
  depends_on = [module.firewall_rules_vpn]
  project_id = var.project_name
  prefix     = var.name
  names      = [format("%s-vpn", var.environment)]
  project_roles = [
    "${var.project_name}=>roles/monitoring.viewer",
    "${var.project_name}=>roles/monitoring.metricWriter",
    "${var.project_name}=>roles/logging.logWriter",
    "${var.project_name}=>roles/stackdriver.resourceMetadata.writer",
    "${var.project_name}=>roles/storage.objectViewer",
  ]
  display_name = format("%s-%s-vpn Service Account", var.name, var.environment)
}

resource "google_compute_instance" "default" {
  project      = var.project_name
  depends_on   = [module.service_accounts_vpn]
  name         = format("%s-%s-vpn", var.name, var.environment)
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["http-server", "https-server", "vpn-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  // local SSD disk
  // scratch_disk {
  //   interface = "SCSI"
  // }

  network_interface {
    network            = var.network_name
    subnetwork_project = var.project_name
    subnetwork         = var.subnetwork

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {

  }

  metadata_startup_script = file("${path.module}/scripts/pritunl-vpn.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = module.service_accounts_vpn.email
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
  labels = tomap(
    {
      "name"        = format("%s-%s-vpn-instance", var.name, var.environment)
      "environment" = var.environment
    },
  )

}

module "firewall_rules_vpn" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  version      = "~> 9.0"
  project_id   = var.project_name
  network_name = var.network_name

  rules = [{
    name                    = format("%s-%s-vpn-server", var.name, var.environment)
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["vpn-server"]
    target_service_accounts = null
    allow = [{
      protocol = "udp"
      ports    = ["10150"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    },

  ]
}

output "vpn_name" {
  description = "The name of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = resource.google_compute_instance.default.*.name
}

output "vpn_zone" {
  description = "The zone of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = resource.google_compute_instance.default.*.zone
}
