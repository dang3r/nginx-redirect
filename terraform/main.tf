provider "google" {
  project = "TODO"
  region  = "us-east1"
}

# Firewall to allow HTTPS traffic
resource "google_compute_firewall" "https" {
  name    = "tf-https-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["redirect"]
}

resource "google_compute_instance" "redirect" {
  name         = "redirect"
  machine_type = "f1-micro"
  zone         = "us-east1-b"
  tags         = ["redirect"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    sshKeys = "${var.ssh_user}:${file("${var.ssh_key_path}")}"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "${var.ssh_user}"
    }

    inline = [<<EOF
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install curl make git socat
curl -L \
  https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
curl https://get.acme.sh | sh
curl -sSL https://get.docker.com/ | sh

echo "Please set your DNS records for the root domain and subdomains!"
echo "The IP of this server is $(curl ifconfig.co)"
echo "You will have 90s..."
sleep 90

echo "Retrieving TLS certificate and key using Letsencrypt..."

# TLS cert, key
pwd
. ~/.bashrc
~/.acme.sh/acme.sh \
  --cert-file /etc/ssl/ssl.cert \
  --key-file /etc/ssl/ssl.key \
  --issue \
  --standalone \
  "${data.null_data_source.domains.outputs["all_domains"]}"

# Nginx
cd /tmp
git clone https://github.com/dang3r/nginx-redirect.git
cd nginx-redirect
sudo make build
export TARGET_URL="${var.target_url}"
export ROOT_DOMAIN="${var.root_domain}"
sudo docker-compose up
EOF
    ]
  }
}

data "null_data_source" "domains" {
  inputs = {
    all_domains = "${join(" ", formatlist("-d %s", var.domains))}"
  }
}
