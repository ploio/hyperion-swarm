# Hyperion

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Description

![Image of components](https://github.com/portefaix/hyperion-swarm/raw/master/docs/hyperion-swarm.png "Hyperion Swarm")

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

* Setup your Docker Swarm cluster informations using IP address of the Swarm master:

        $ alias dockerswarm="docker -H=tcp://x.x.x.x:2375"

* Check cluster informations :

        Containers: 4
         Running: 2
         Paused: 0
         Stopped: 2
        Images: 2
        Server Version: swarm/1.2.0
        Role: primary
        Strategy: spread
        Filters: health, port, dependency, affinity, constraint
        Nodes: 2
          hyperion-swarm-node-0: 10.0.0.5:2375
           └ Status: Healthy
           └ Containers: 2
           └ Reserved CPUs: 0 / 1
           └ Reserved Memory: 0 B / 3.806 GiB
           └ Labels: executiondriver=, kernelversion=3.16.0-4-amd64, operatingsystem=Debian GNU/Linux 8 (jessie), storagedriver=aufs
           └ Error: (none)
           └ UpdatedAt: 2016-04-20T10:44:54Z
           └ ServerVersion: 1.11.0
          hyperion-swarm-node-1: 10.0.0.4:2375
           └ Status: Healthy
           └ Containers: 2
           └ Reserved CPUs: 0 / 1
           └ Reserved Memory: 0 B / 3.806 GiB
           └ Labels: executiondriver=, kernelversion=3.16.0-4-amd64, operatingsystem=Debian GNU/Linux 8 (jessie), storagedriver=aufs
           └ Error: (none)
           └ UpdatedAt: 2016-04-20T10:44:56Z
           └ ServerVersion: 1.11.0
        Plugins:
         Volume:
         Network:
        Kernel Version: 3.16.0-4-amd64
        Operating System: linux
        Architecture: amd64
        CPUs: 2
        Total Memory: 7.612 GiB
        Name: hyperion-swarm-master



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
