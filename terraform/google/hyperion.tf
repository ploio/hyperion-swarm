resource "template_file" "swarm-manager-service" {
  template = "../swarm-manager.service"
  vars {
    swarm_version = "${var.swarm_version}"
    consul_server = "http://${var.cluster_name}-discover.c.${var.gce_project}.internal"
  }
}

resource "template_file" "swarm-agent-service" {
  template = "../swarm-agent.service"
  vars {
    swarm_version = "${var.swarm_version}"
    consul_server = "http://${var.cluster_name}-discover.c.${var.gce_project}.internal"
    swarm_master = "http://${var.cluster_name}-master.c.${var.gce_project}.internal"
  }
}

resource "template_file" "docker-service" {
  template = "../docker.service"
}

resource "template_file" "consul-config" {
  template = "../config.json"
}

resource "template_file" "consul-service" {
  template = "../consul.service"
  # vars {
  #   consul_server = "http://${var.cluster_name}-discover.c.${var.gce_project}.internal"
  # }
}


resource "google_compute_network" "hyperion-network" {
  name = "hyperion"
  ipv4_range = "${var.gce_ipv4_range}"
}

# Firewall
resource "google_compute_firewall" "hyperion-firewall-external" {
  name = "hyperion-firewall-external"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",   # SSH
      "80",   # HTTP
      "443",  # HTTPS
      "2375", # Docker Swarm
      "8500", # Consul
    ]
  }

}

resource "google_compute_firewall" "hyperion-firewall-internal" {
  name = "hyperion-firewall-internal"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["${google_compute_network.hyperion-network.ipv4_range}"]

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
}

resource "google_compute_address" "hyperion-master" {
  name = "hyperion-master"
}

resource "google_compute_instance" "hyperion-discover" {
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-discover"
  description = "Docker Swarm Discover"
  machine_type = "${var.gce_machine_type_discover}"

  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      // ephemeral ip
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/consul/data",
      "/sbin/ifconfig eth0 | grep \"inet addr\" | awk '{ print substr($2,6) }' > /tmp/ip_addr",
      "sudo cat <<'EOF' > /tmp/consul.service\n${template_file.consul-service.rendered}\nEOF",
      "sudo mv /tmp/consul.service /lib/systemd/system/",
      "sudo cat <<'EOF' > /tmp/config.json\n${template_file.consul-config.rendered}\nEOF",
      "sudo mv /tmp/config.json /etc/consul/",
      "sudo sed -i \"s/__IP_ADDR__/$(cat /tmp/ip_addr)/g\" /etc/consul/config.json",
      "sudo systemctl daemon-reload",
      "sudo systemctl start consul.service",
    ]
  }
  depends_on = [
    "template_file.consul-service",
    "template_file.consul-config",
  ]
}

resource "google_compute_instance" "hyperion-master" {
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-master"
  description = "Docker Swarm master"
  machine_type = "${var.gce_machine_type_master}"

  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      nat_ip = "${google_compute_address.hyperion-master.address}"
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo cat <<'EOF' > /tmp/swarm-manager.service\n${template_file.swarm-manager-service.rendered}\nEOF",
      "sudo cat <<'EOF' > /tmp/docker.service\n${template_file.docker-service.rendered}\nEOF",
      "sudo mv /tmp/swarm-manager.service /lib/systemd/system/",
      "sudo mv /tmp/docker.service /lib/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker.service",
      "sudo systemctl start swarm-manager.service"
    ]
  }
  depends_on = [
    "template_file.swarm-manager-service",
    "template_file.docker-service"
  ]
}

resource "google_compute_instance" "hyperion-nodes" {
  count = "${var.hyperion_nb_nodes}"
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-node-${count.index}" // => `xxx-node-{0,1,2}`
  description = "Docker Swarm node ${count.index}"
  machine_type = "${var.gce_machine_type_node}"

  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      // ephemeral ip
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo cat <<'EOF' > /tmp/swarm-agent.service\n${template_file.swarm-agent-service.rendered}\nEOF",
      "sudo cat <<'EOF' > /tmp/docker.service\n${template_file.docker-service.rendered}\nEOF",
      "sudo mv /tmp/swarm-agent.service /usr/lib/systemd/system/",
      "sudo mv /tmp/docker.service /usr/lib/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker.service",
      "sudo systemctl start swarm-agent.service"
    ]
  }
  depends_on = [
    "template_file.swarm-agent-service",
    "template_file.docker-service"
  ]
}
