provider "google" {
  credentials = file("/Users/yagizgurdamar/Downloads/cs-436-421508-d538efc809bc.json")
  project     = "cs-436-421508"
  region      = "us-central1"
  alias       = "first"
}




#instance kurulumu ilki için
resource "google_compute_instance" "vm_instance_one" {
  provider = google.first
  name         = "example-instance-one"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}



 