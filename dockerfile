FROM tomcat:7.0.109-jdk8-openjdk-slim-buster

ENV TZ="Europe/Berlin"

ENV LANG="de_DE.UTF-8"
ENV LC_ALL="de_DE.UTF-8"

# Update und Pakete installieren
# Develop
RUN apt update && apt upgrade -y && apt -y install curl locales vim procps libterm-readline-perl-perl

# Production
# RUN apt update && apt upgrade -y && apt -y install locales libterm-readline-perl-perl

# Install locales
RUN sed -i 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

# Update Buster auf Bullseye
RUN sed -i 's:buster/updates:bullseye-security:' /etc/apt/sources.list
RUN sed -i 's:buster:bullseye:' /etc/apt/sources.list
RUN apt update
RUN apt upgrade --without-new-pkgs -y

# Cleanup Bullseye
RUN apt -y clean
RUN apt -y autoclean
RUN apt -y autoremove
RUN apt -y purge

# Update Bullseye auf Bookworm
RUN apt -y update
RUN apt -y upgrade
RUN apt -y full-upgrade
RUN sed -i 's:bullseye:bookworm:' /etc/apt/sources.list
RUN apt -y update
RUN apt -y upgrade --without-new-pkgs
RUN apt -y upgrade

# Cleanup Bookworm
RUN apt -y clean
RUN apt -y autoclean
RUN apt -y autoremove
RUN apt -y purge

# Josso Konfiguration kopieren
COPY josso-conf/jaas.conf /usr/local/tomcat/conf/

# Josso Installation
COPY ./josso-installer/josso-latest /josso-installer
RUN echo "agent install --target /usr/local/tomcat/ --platform tc70;exit" | /josso-installer/bin/josso-gsh

# Catalina config common.loader value adjustment for josso libs
RUN sed -i 's|^common.loader=.*|common.loader=\${catalina.base}/lib,\${catalina.base}/lib/*.jar,\${catalina.home}/lib,\${catalina.home}/lib/*.jar,\${catalina.base}/shared/classes,\${catalina.base}/shared/lib/*.jar,\${catalina.home}/shared/classes,\${catalina.home}/shared/lib/*.jar|g' /usr/local/tomcat/conf/catalina.properties
RUN mkdir -p /usr/local/tomcat/shared/classes
RUN mkdir -p /usr/local/tomcat/shared/lib
