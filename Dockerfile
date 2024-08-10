FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

ENV DISPLAY :0

ENV APP opera

ENV USERNAME developer

# stable | beta | developer
ENV STAGE stable

WORKDIR /app

RUN apt update

RUN apt-get install -y --no-install-recommends \
    dirmngr ca-certificates \
    software-properties-common apt-transport-https curl \
    sudo

RUN curl -fsSL https://deb.opera.com/archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/opera.gpg > /dev/null

RUN echo deb [arch=amd64 signed-by=/usr/share/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free | sudo tee /etc/apt/sources.list.d/opera.list

RUN apt update

RUN apt install -y $APP-$STAGE

# create and switch to a user
RUN echo "backus ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN useradd --no-log-init --home-dir /home/$USERNAME --create-home --shell /bin/bash $USERNAME
RUN adduser $USERNAME sudo

USER $USERNAME

WORKDIR /home/$USERNAME

CMD $APP