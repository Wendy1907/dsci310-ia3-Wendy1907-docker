FROM rocker/rstudio:4.4.2

USER root

RUN apt-get update && apt-get install -y \
    libcur14-openssl-dev \
    libssl-dev \
    libxm12-dev \
    && rm -rf /var/lib/apt/lists/*

USER rstudio
WORKDIR /home/rstudio/project
