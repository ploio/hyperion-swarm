output "swarm-cluster" {
    value = "\nDocker Host: tcp://${google_compute_instance.hyperion-master.network_interface.0.access_config.0.nat_ip}:2375\n"
}

output "consul-cluster" {
  value = "\nConsul Host: ${google_compute_instance.hyperion-discover.network_interface.0.access_config.0.nat_ip}:8500\n"
}
