# Alastria Node
# Copyright (C) 2019 Alastria <support@alastria.io>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM ubuntu:16.04

LABEL maintainer "Alejandro Alfonso (DigitelTS) (alejandro.alfonso@madisonmk.com)"

# alejandro.alfonso
# revisar libsodium
RUN apt-get update \
	&& apt-get install -y git curl dnsutils net-tools nginx nginx-extras psmisc vim nano \
	&& apt-get install -y software-properties-common make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev sysvbanner libleveldb-dev libdb5.3-dev

# alejandro.alfonso
# TBD... descarga local o remota?
#COPY ./installation-bin/go1.9.5.linux-amd64.tar.gz /tmp
ADD https://dl.google.com/go/go1.9.5.linux-amd64.tar.gz /tmp
#COPY ./installation-bin/constellation-0.3.2-ubuntu1604.tar.xz /tmp
ADD https://github.com/jpmorganchase/constellation/releases/download/v0.3.2/constellation-0.3.2-ubuntu1604.tar.xz /tmp

COPY ./installation-scripts/bootstrap.sh /root/alastria-build/bootstrap.sh
RUN /root/alastria-build/bootstrap.sh

VOLUME /root/alastria-node
EXPOSE 80 443 8443 9000 21000 21000/udp 22000 8443

COPY ./installation-scripts/entrypoint.sh /root/alastria-build/entrypoint.sh
WORKDIR /root/alastria-build
ENTRYPOINT ["./entrypoint.sh"]
