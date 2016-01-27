# Hyperion

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Description

[hyperion][] creates a Cloud environment :

- Identical machine images creation is performed using [Packer][]
- Orchestrated provisioning is performed using [Terraform][]
- Applications managment is performed using [Docker Swarm][] and [Wagl][]

## Docker Swarm, Wagl and Consul

In [Docker Swarm][] :

- node: a host machine that is only responsible for running containers
- manager : the service a user uses for managing containers across the registered Swarm Node(s).
- consul : the service discovery used (See https://docs.docker.com/swarm/discovery/)





## Initialization

Initialize environment:

    $ make init


## Machine image

Read guides to creates the machine for a cloud provider :

* [Google cloud](https://github.com/portefaix/hyperion-swarm/blob/packer/google/README.md)

## Cloud infratructure

Read guides to creates the infrastructure :

* [Google cloud](https://github.com/portefaix/hyperion-swarm/blob/infra/google/README.md)


## Usage

* Setup your Docker Swarm cluster informations :

        $ alias dockerswarm="docker -H=tcp://x.x.x.x:2375"

* Check cluster informations :

        $ dockerswarm info


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
