# syntax=docker/dockerfile:1@sha256:38387523653efa0039f8e1c89bb74a30504e76ee9f565e25c9a09841f9427b05

ARG BUILD_FROM=ghcr.io/chukysoria/baseimage-alpine:v0.8.9-3.22@sha256:b85ba89565a671992916d7bf020d688aba9623dfc53959c1a412f8ef930032fc
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
    bind-tools=9.20.13-r0 \
    logrotate=3.21.0-r1 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version

# add local files
COPY root/ /
