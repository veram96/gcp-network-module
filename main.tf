locals {
  username = "mavera"
}

# module "network" {
#   source = "./modules/nertwork"
#   project = var.project
#   username = local.username
#   region = var.region
# }

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "6.0.1"
  network_name = "${local.username}-vpc-module"
  project_id  = var.project
  subnets = [
    {
      subnet_name = "${local.username}-public-subnet"
      subnet_ip = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name = "${local.username}-private-subnet"
      subnet_ip = "10.10.11.0/24"
      subnet_region = var.region
    }
  ]
  firewall_rules  = [
        {
          name    = "${local.username}-http"
          description             = null
          direction               = "INGRESS"
          priority                = null
          source_tags             = null
          source_service_accounts = null
          target_tags             = null
          target_service_accounts = null
          allow = [
            {
              protocol = "tcp"
              ports    = ["80"]
            }
          ]
          deny = []
          log_config = {
            metadata = "INCLUDE_ALL_METADATA"
          }
          ranges = ["0.0.0.0/0"]
        },
        {
          name    = "${local.username}-https"
          description             = null
          direction               = "INGRESS"
          priority                = null
          source_tags             = null
          source_service_accounts = null
          target_tags             = null
          target_service_accounts = null
          allow = [
            {
              protocol = "tcp"
              ports    = ["443"]
            }
          ]
          deny = []
          log_config = {
            metadata = "INCLUDE_ALL_METADATA"
          }
          ranges = ["0.0.0.0/0"]
        },
        {
          name    = "${local.username}-ssh"
          description             = null
          direction               = "INGRESS"
          priority                = null
          source_tags             = null
          source_service_accounts = null
          target_tags             = null
          target_service_accounts = null
          allow = [
            {
              protocol = "tcp"
              ports    = ["22"]
            }
          ]
          deny = []
          log_config = {
            metadata = "INCLUDE_ALL_METADATA"
          }
          ranges = ["0.0.0.0/0"]
        }
      ]
  }

resource "google_compute_instance" "default" {
  name         = "${local.username}-terraform-course"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = module.network.network_id
    subnetwork = module.network.subnets_ids[0]
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    scopes = ["cloud-platform"]
  }
}