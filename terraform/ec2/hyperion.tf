resource "template_file" "swarm-manager-service" {
  template = "../swarm-manager.service"
  vars {
    swarm_version = "${var.swarm_version}"
    consul_server = "${var.cluster_name}-discover.c.${var.gce_project}.internal"
  }
}

resource "template_file" "swarm-agent-service" {
  template = "../swarm-agent.service"
  vars {
    swarm_version = "${var.swarm_version}"
    consul_server = "${var.cluster_name}-discover.c.${var.gce_project}.internal"
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
}

resource "aws_key_pair" "deployer" {
  key_name = "${var.aws_key_name}"
  public_key = "${file("${var.aws_ssh_public_key}")}"
}

resource "aws_vpc" "hyperion-network" {
  cidr_block = "${var.aws_vpc_cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "hyperion"
  }
}

resource "aws_subnet" "hyperion-network" {
  vpc_id = "${aws_vpc.hyperion-network.id}"
  cidr_block = "${var.aws_subnet_cidr_block}"
  map_public_ip_on_launch = true
  tags {
    Name = "hyperion"
  }
}

resource "aws_internet_gateway" "hyperion-network" {
  vpc_id = "${aws_vpc.hyperion-network.id}"
}

resource "aws_route_table" "hyperion-network" {
  vpc_id = "${aws_vpc.hyperion-network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hyperion-network.id}"
  }
}

resource "aws_route_table_association" "hyperion-network" {
  subnet_id = "${aws_subnet.hyperion-network.id}"
  route_table_id = "${aws_route_table.hyperion-network.id}"
}

resource "aws_security_group" "hyperion-network" {
  name = "hyperion"
  description = "Hyperion security group"
  vpc_id = "${aws_vpc.hyperion-network.id}"
  ingress {
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "hyperion"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.hyperion-master.id}"
  vpc = true
  connection {
    # host = "${aws_eip.ip.public_ip}"
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }
}

resource "aws_instance" "hyperion-discover" {
  ami = "${var.aws_image}"
  instance_type = "${var.aws_instance_type_discover}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.hyperion-network.id}"
  security_groups = [
    "${aws_security_group.hyperion-network.id}",
  ]
  tags {
    Name = "hyperion-discover"
  }

  connection {
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
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

resource "aws_instance" "hyperion-master" {
  ami = "${var.aws_image}"
  instance_type = "${var.aws_instance_type_master}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.hyperion-network.id}"
  security_groups = [
    "${aws_security_group.hyperion-network.id}",
  ]
  tags {
    Name = "hyperion-master"
  }

  connection {
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cat <<'EOF' > /tmp/swarm-manager.service\n${template_file.swarm-manager-service.rendered}\nEOF",
      "sudo mv /tmp/swarm-manager.service /lib/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker.service",
      "sudo systemctl start swarm-manager.service"
    ]
  }

  depends_on = [
    "template_file.swarm-manager-service",
  ]

}


resource "aws_instance" "hyperion-nodes" {
  depends_on = ["aws_eip.ip"]
  count = "${var.hyperion_nb_nodes}"
  ami = "${var.aws_image}"
  instance_type = "${var.aws_instance_type_node}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.hyperion-network.id}"
  security_groups = [
    "${aws_security_group.hyperion-network.id}",
  ]

  tags {
    Name = "hyperion-node-${count.index}"
  }

  connection {
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "/sbin/ifconfig eth0 | grep \"inet addr\" | awk '{ print substr($2,6) }' > /tmp/ip_addr",
      // For ID duplicated: https://github.com/docker/swarm/issues/380
      "sudo cat <<'EOF' > /tmp/swarm-agent.service\n${template_file.swarm-agent-service.rendered}\nEOF",
      "sudo cat <<'EOF' > /tmp/docker.service\n${template_file.docker-service.rendered}\nEOF",
      "sudo sed -i \"s/__IP_ADDR__/$(cat /tmp/ip_addr)/g\" /tmp/swarm-agent.service",
      "sudo mv /tmp/swarm-agent.service /lib/systemd/system/",
      "sudo mv /tmp/docker.service /lib/systemd/system/",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker.service",
      "sudo rm /etc/docker/key.json",
      "sudo systemctl restart docker.service",
      "sudo systemctl start swarm-agent.service"
    ]
  }

  depends_on = [
    "template_file.swarm-agent-service",
    "template_file.docker-service"
  ]

}
