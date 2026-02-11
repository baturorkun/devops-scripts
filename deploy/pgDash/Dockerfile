FROM ubuntu:20.04

ENV PGDASH_VERSION 3.0.0

RUN apt-get update
RUN apt-get -yq install wget

RUN wget https://packages.rapidloop.com/downloads/pgdash-server_${PGDASH_VERSION}_amd64.deb
RUN dpkg -i pgdash-server_${PGDASH_VERSION}_amd64.deb

COPY pgdash.cfg /etc/pgdash
COPY ABCDE-FGHIJ-KLMNO-PQRST.lic /etc/pgdash

VOLUME /var/lib/pgdash

ENTRYPOINT ["/usr/sbin/pgdashd"]