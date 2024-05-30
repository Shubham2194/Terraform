resource "google_compute_instance" "vm" {
  name         = var.name
  machine_type = var.type
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 100
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  tags = ["http-server", "https-server"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    set -e

    exec > /var/log/startup-script.log 2>&1
    echo "Updating package list"
    apt-get update
    echo "Installing necessary packages"
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    echo "Adding Docker GPG key"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    echo "Adding Docker APT repository"
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"    
    apt-get update
    echo "Installing Docker"
    apt-get install -y docker-ce
    echo "Installing Docker Compose"
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "Enabling Docker service"
    systemctl enable docker
    echo "Starting Docker service"
    systemctl start docker
    echo "Docker and Docker Compose installation complete"
  EOF
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-qa"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https-qa"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
}
