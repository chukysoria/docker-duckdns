# syntax=docker/dockerfile:1@sha256:dabfc0969b935b2080555ace70ee69a5261af8a8f1b4df97b9e7fbcf6722eddf

ARG BUILD_FROM=ghcr.io/chukysoria/baseimage-alpine:v0.8.10-3.22@sha256:abe64ada59bc10fadd6cfb05358e95496eb34debd5968698dd7be12168638f61
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
