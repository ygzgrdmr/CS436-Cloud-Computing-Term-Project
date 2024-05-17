provider "google" {
  credentials = file("/Users/yagizgurdamar/Downloads/cs-436-421508-d538efc809bc.json")
  project     = "cs-436-421508"
  region      = "us-central1"
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"
  project = "cs-436-421508"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"
  project = "cs-436-421508"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "allow_custom_port" {
  name    = "allow-custom-port"
  network = "default"
  project = "cs-436-421508"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["custom-port"]
}

resource "google_compute_instance" "vm_instance" {
  count    = 3
  name     = "example-instance-${count.index}"
  machine_type = "e2-micro"
  zone     = "us-central1-a"

  tags = ["http-server", "https-server", "custom-port"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-jammy-v20240501"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = file("startup_script.sh")

  metadata = {
    ssh-keys = "myuser:${file("${path.module}/my_ssh_key.pub")}"
  }
}
