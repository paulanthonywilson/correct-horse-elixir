FROM ubuntu:latest

ENV REFRESHED_AT=2020-06-10 \
    DEBIAN_FRONTEND=noninteractive 

RUN echo '. /root/.asdf/asdf.sh' >> /etc/bash.bashrc

WORKDIR /opt/src

RUN apt-get update -y 
RUN apt-get install -y apt-utils

RUN apt-get install -y git curl locales 

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN apt-get install -y curl build-essential autoconf m4 libncurses5-dev \
    libssh-dev unzip bsdmainutils default-jdk fop

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8  
ENV PATH="${PATH}:~/.asdf/shims:~/.asdf/bin"

RUN ~/.asdf/bin/asdf plugin add erlang 
RUN ~/.asdf/bin/asdf plugin add elixir 
RUN ~/.asdf/bin/asdf install erlang 23.0
RUN ~/.asdf/bin/asdf install elixir 1.10.3-otp-23

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 