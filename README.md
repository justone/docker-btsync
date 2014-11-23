# BTSync in Docker

This repo contains instructions on how to build a docker image that will run
[BTSync](https://www.btsync.com/).

## Docker registry

This image is available on the [Docker registry](https://index.docker.io/) as
[nate/btsync](https://index.docker.io/u/nate/btsync/):

```
$ docker pull nate/btsync
```

## Why another BTSync docker image?

There are nearly [50 images in the
registry](https://registry.hub.docker.com/search?q=btsync&searchfield=) for
BTSync already.  I looked through several of them before creating this one.
Here are the unique features of this image:

* This image can run without a host volume, ideally for sync peers that are for sharing data and not backing it up.
* Runs as a dynamically created user with the same UID/GID as the host volume.  This means that files that are sync'd can be edited from the host because they're effectively owned by the same user.

## Building

```
$ git clone https://github.com/justone/docker-btsync
$ docker build --rm -t nate/btsync .
```

## Running

This will run with a temporary home directory, so all BTSync configuration and
data will be lost when the container is removed:

```
$ docker run -d -p 8888:8888 -p 55555:55555 nate/btsync
```

You can specify a host volume and that will be used for BTSync configuration
and data.

```
$ docker run -d -p 8888:8888 -p 55555:55555 -v /host/path:/btsync nate/btsync
```

# License

Copyright © 2014 Nate Jones

Distributed under the MIT license.
