# Hyperion

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Description

[hyperion][] creates a Cloud environment :

- Identical machine images creation is performed using [Packer][]
- Orchestrated provisioning is performed using [Terraform][]
- Applications managment is performed using [Docker Swarm][] and [Wagl][]

## Docker Swarm and Wagl


## Initialization

Initialize environment:

    $ make init

## Machine image

Read guides to creates the machine for a cloud provider :

* [Google cloud](https://github.com/portefaix/hyperion-swarm/blob/packer/google/README.md)

## Cloud infratructure

Read guides to creates the infrastructure :

* [Google cloud](https://github.com/portefaix/hyperion-swarm/blob/infra/google/README.md)
* [AWS](https://github.com/portefaix/hyperion-swarm/blob/infra/aws/README.md)
* [Digitalocean](https://github.com/portefaix/hyperion-swarm/blob/infra/digitalocean/README.md)
* [Openstack](https://github.com/portefaix/hyperion-swarm/blob/infra/openstack/README.md)


## Usage




## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE][] for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[hyperion]: https://github.com/portefaix/hyperion-swarm
[LICENSE]: https://github.com/portefaix/hyperion-swarm/blob/master/LICENSE
[Issue tracker]: https://github.com/portefaix/hyperion-swarm/issues

[Docker Swarm]: https://github.com/docker/swarm
[Wagl]: https://github.com/ahmetalpbalkan/wagl

[terraform]: https://terraform.io
[packer]: https://packer.io

[badge-license]: https://img.shields.io/badge/license-Apache_2-green.svg
[badge-release]: https://img.shields.io/github/release/portefaix/hyperion-swarm.svg
