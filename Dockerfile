# syntax=docker/dockerfile:1

ARG BUILD_FROM=ghcr.io/chukysoria/baseimage-alpine:3.18-v0.2.0

FROM ${BUILD_FROM} 

# set version label
ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_EXT_RELEASE="1.0.0"
LABEL build_version="Chukyserver.io version:- ${BUILD_VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chukysoria"

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    logrotate=3.21.0-r1

# add local files
COPY root/ /
