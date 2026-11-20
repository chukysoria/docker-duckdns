# syntax=docker/dockerfile:1@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

ARG BUILD_FROM=ghcr.io/chukysoria/baseimage-alpine:v2.0.9-3.24@sha256:6e754e255b13f175d0a8d7937def6ebabdd357df850a1a8a8f453fa2ec4a8767
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
    bind-tools=9.20.30-r0 \
    logrotate=3.22.0-r0 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version

# add local files
COPY root/ /
