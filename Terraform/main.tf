provider "google" {
  credentials = file("/Users/yagizgurdamar/Downloads/cs-436-421508-d538efc809bc.json")
  project     = "cs-436-421508"
  region      = "us-central1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "example-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}