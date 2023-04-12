#  PC, PUBLICA, PRIVADA, http, https y ssh

resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = "${var.username}-course-network"
  auto_create_subnetworks = false
}         


resource "google_compute_subnetwork" "public" {
  name          = "${var.username}-public-subnetwork"
  ip_cidr_range = "10.2.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.username}-private-subnetwork"
  ip_cidr_range = "10.2.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "http" {
  name    = "${var.username}-http"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "https" {
  name    = "${var.username}-https"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.username}-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
