output "vpc" {
  value = google_compute_network.vpc_network.id
}

output "public_subnetwork" {
  value = google_compute_subnetwork.public.id
}

output "private_subnetwork" {
  value = google_compute_subnetwork.private.id
}
