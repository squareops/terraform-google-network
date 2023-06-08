module "service_accounts_vpn" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 3.0"
  count      = var.create_vpn ? 1 : 0
  depends_on = [module.firewall_rules]
  project_id = local.project_name
  prefix     = local.name
  names      = [format("%s-vpn", local.environment)]
  project_roles = [
    "${local.project_name}=>roles/monitoring.viewer",
    "${local.project_name}=>roles/monitoring.metricWriter",
    "${local.project_name}=>roles/logging.logWriter",
    "${local.project_name}=>roles/stackdriver.resourceMetadata.writer",
    "${local.project_name}=>roles/storage.objectViewer",
  ]
  display_name = format("%s-%s-vpn Service Account", local.name, local.environment)
}

resource "google_compute_instance" "default" {
  project      = local.project_name
  count        = var.create_vpn ? 1 : 0
  depends_on   = [module.service_accounts_vpn]
  name         = format("%s-%s-vpn", local.name, local.environment)
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["http-server", "https-server", "vpn-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  // Local SSD disk
  // scratch_disk {
  //   interface = "SCSI"
  // }

  network_interface {
    network            = module.vpc.network_name
    subnetwork_project = local.project_name
    subnetwork         = format("%s-%s-public-subnet", local.name, local.environment)

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {

  }

  metadata_startup_script = file("${path.module}/scripts/pritunl-vpn.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = module.service_accounts_vpn[0].email
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
      "name"        = format("%s-%s-vpn-instance", local.name, local.environment)
      "environment" = local.environment
    },
  )

}

module "firewall_rules_vpn" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  version      = "~> 7.0"
  project_id   = local.project_name
  network_name = module.vpc.network_name
  depends_on   = [module.vpc]

  rules = [{
    name                    = format("%s-%s-vpn-server", local.name, local.environment)
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
