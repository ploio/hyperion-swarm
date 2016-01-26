variable "gce_credentials" {
  description = "Path to the JSON file used to describe your account credentials, downloaded from Google Cloud Console."
}

variable "gce_project" {
  description = "The name of the project to apply any resources to."
}

variable "gce_ssh_user" {
  description = "SSH user."
}

variable "gce_ssh_public_key" {
  description = "Path to the ssh key to use"
}

variable "gce_ssh_private_key_file" {
  description = "Path to the SSH private key file."
}

variable "gce_region" {
  description = "The region to operate under."
  default = "us-central1"
}

variable "gce_zone" {
  description = "The zone that the machines should be created in."
  default = "us-central1-a"
}

variable "gce_ipv4_range" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "10.0.0.0/16"
}

variable "gce_image" {
  description = "The name of the image to base the launched instances."
  default = "hyperion-swarm-0-3-0-v20160126"
}

variable "gce_machine_type_discover" {
  description = "The machine type to use for the hyperion discovering service ."
  default = "n1-standard-1"
}

variable "gce_machine_type_master" {
  description = "The machine type to use for the hyperion master ."
  default = "n1-standard-1"
}

variable "gce_machine_type_node" {
  description = "The machine type to use for the hyperion node ."
  default = "n1-standard-1"
}

variable "cluster_name" {
  default = "hyperion-swarm"
}

variable "hyperion_nb_nodes" {
  description = "The number of nodes."
  default = "2"
}

variable "swarm_version" {
  description = "Version of Docker Swarm."
  default = "1.0.0"
}
