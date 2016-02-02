# Terraform templates for Amazon Web Services

This project contains [Terraform][] templates to help you deploy [hyperion-rancher][] on [AWS][].

## Prerequisites

* An [Amazon Web Services account](http://aws.amazon.com/)
* An [AWS Access and Secret Access Keys](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
* An [AWS EC2 Key Pairs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)


## Configure

The available variables that can be configured are:

* `aws_access_key`: AWS access key
* `aws_secret_key`: AWS secret key
* `aws_key_name`: The SSH key name to use for the instances
* `aws_ssh_private_key_file`: Path to the SSH private key file
* `aws_ssh_user`: SSH user (default `admin`)
* `aws_region`: AWS region (default `eu-west-1`)
* `aws_vpc_cidr_block`: The IPv4 address range that machines in the network are assigned to, represented as a CIDR block (default `10.0.0.0/16`)
* `aws_subnet_cidr_block`: The IPv4 address range that machines in the network are assigned to, represented as a CIDR block (default `10.0.1.0/24`)
* `aws_image`: The name of the image to base the launched instances
* `aws_instance_type_master`: The machine type to use for the Hyperion master instance (default `m3.medium`)

Copy and renamed *terraform.tfvars.example* to *terraform.tfvars*.

## Deploy

Deploy your cluster

    $ terraform apply --var-file=terraform.tfvars

## Destroy

Destroy the cluster :

    $ terraform destroy --var-file=terraform.tfvars

## Updating



[Terraform]: https://www.terraform.io/
[AWS]: https://aws.amazon.com/

[hyperion-rancher]: http://github.com/portefaix/hyperion-rancher
