output "swarm-cluster" {
    value = "\nexport DOCKER_HOST=tcp://${google_compute_instance.hyperion-master.network_interface.0.access_config.0.nat_ip}:2375"
}
