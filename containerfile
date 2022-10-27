FROM docker.io/python:3.10.7-alpine3.16

MAINTAINER yuu <yuuyin@protonmail.com>

COPY . /opt/parsifal
WORKDIR /opt/parsifal

RUN apk add build-base libpq-dev curl git \
    && pip install --requirement /parsifal/requirements/local.txt
