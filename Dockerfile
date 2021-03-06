#Dockerfile
FROM ubuntu:18.04
RUN useradd -d /home/taichi -m -s /bin/bash taichi
#ENV APP_ROOT /home/taichi/www/myproject
WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y upgrade && \
    apt -y install vim \
                   git \
                   nginx \
                   postgresql \
                   libpq-dev \
                   python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip install -U pip && \
    : "hash を実行することで、pip 18 における pip install 時の ImportError: cannot import name 'main' を回避" && \
    hash -r pip && \
    pip install -r requirements.txt && \
#    ln -s ${APP_ROOT}/my_nginx.conf /etc/nginx/sites-enabled/ && \
    echo 'postgres:postgres' | chpasswd

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# bash から日本語入力できない症状への対処
#RUN apt-get install -y language-pack-ja-base language-pack-ja
#ENV LANG=ja_JP.UTF-8

USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "ALTER ROLE postgres WITH PASSWORD 'postgres';"

USER root