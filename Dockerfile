# syntax=docker/dockerfile:1@sha256:9857836c9ee4268391bb5b09f9f157f3c91bb15821bb77969642813b0d00518d

ARG BUILD_FROM=ghcr.io/chukysoria/baseimage-alpine:v0.7.14-3.21@sha256:b48aae1f577b501f128277137637eeeba5ac1b061dab6fd1385742949838cd7a
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
    bind-tools=9.18.36-r0 \
    logrotate=3.21.0-r1 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version

# add local files
COPY root/ /
