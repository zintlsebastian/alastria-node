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

# no arguments for Dockerhub version
ARG DOCKER_VERSION=latest

RUN apt-get -y upgrade &&\
      apt-get install -y git curl dnsutils net-tools nginx nginx-extras vim nano

# TODO: move these scripts, and move to entrypoint.sh
COPY ./alastria-access-point/nginx/conf.d/access-point.conf /etc/nginx/conf.d/access-point.conf
COPY ./alastria-access-point/nginx/conf.d/blacklist /etc/nginx/conf.d/blacklist
COPY ./alastria-access-point/nginx/conf.d/whitelist /etc/nginx/conf.d/whitelist
COPY ./alastria-node /root/alastria-node

# TODO: remove monitor.sh script
RUN /root/alastria-node/scripts/bootstrap.sh
RUN /root/alastria-node/scripts/monitor.sh build
# dejamos la parametrizacion para primer init
# RUN /root/alastria-node/scripts/init.sh auto $NODE_TYPE $NODE_NAME

VOLUME /root/alastria-node
EXPOSE 80 443 8443 9000 21000 21000/udp 22000 8443

COPY entrypoint.sh /usr/bin/
WORKDIR /root/alastria-node/scripts
ENTRYPOINT ["entrypoint.sh"]