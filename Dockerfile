# syntax=docker/dockerfile:1

ARG BUILD_FROM=ghcr.io/chukysoria/baseimage-alpine:v0.6.14-3.20

FROM ${BUILD_FROM} 

# set version label
ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_EXT_RELEASE="1.1.0"
LABEL build_version="Chukyserver.io version:- ${BUILD_VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chukysoria"

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    bind-tools=9.18.27-r0 \
    logrotate=3.21.0-r1

# add local files
COPY root/ /
