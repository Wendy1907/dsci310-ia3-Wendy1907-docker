FROM rocker/rstudio:4.4.2

# Install system dependencies
USER root

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Switch back to rstudio user
USER rstudio
WORKDIR /home/rstudio/project

# Copy renv infrastructure with correct ownership
COPY --chown=rstudio:rstudio renv.lock renv.lock
COPY --chown=rstudio:rstudio renv/activate.R renv/activate.R
COPY --chown=rstudio:rstudio renv/settings.json renv/settings.json
COPY --chown=rstudio:rstudio .Rprofile .Rprofile

# Install renv and restore packages
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')" && \
    R -e "renv::restore()"

# Copy rest of the project
COPY --chown=rstudio:rstudio . .
