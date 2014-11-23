FROM ubuntu:14.04
MAINTAINER Nate Jones <nate@endot.org>

RUN apt-get update && apt-get install curl -y
RUN curl -o /tmp/btsync.tgz http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable && tar -C /usr/bin/ -xzvf /tmp/btsync.tgz && rm /tmp/btsync.tgz
RUN curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" && chmod +x /usr/bin/gosu

EXPOSE 8888
EXPOSE 55555

ADD run.sh /run.sh
CMD ["/run.sh"]
