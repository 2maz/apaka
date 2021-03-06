FROM ubuntu:16.04

MAINTAINER 2maz "https://github.com/2maz"

RUN apt update
RUN apt upgrade -y
RUN apt install -y ruby ruby-dev git locales tzdata vim
RUN apt install -y wget gem2deb reprepro apache2 cmake automake pbuilder cowdancer
RUN apt-file update
RUN service apache2 start
RUN echo "Europe/Berlin" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=de_DE.UTF-8; export LANG=de_DE.UTF-8; export LC_ALL=de_DE.UTF-8; locale-gen de_DE.UTF-8; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN useradd -ms /bin/bash docker
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER docker
WORKDIR /home/docker
ENV LANG de_DE.UTF-8
ENV LANG de_DE:de
ENV LC_ALL de_DE.UTF-8
ENV GEM_HOME=/home/docker/.gems/ruby/2.3.0
ENV PATH=$GEM_HOME/bin:$PATH

RUN git clone https://github.com/2maz/apaka /home/docker/apaka
RUN sed -i 's#gems_install_path.*#gems_install_path: /home/docker/.gems#' /home/docker/apaka/test/workspace/.autoproj/config.yml
RUN git config --global user.name 'Apaka4docker'
RUN git config --global user.email 'apaka@docker'
RUN gem install bundler
RUN gem install autoproj
RUN gem install yard
