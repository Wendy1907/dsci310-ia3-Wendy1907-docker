FROM rocker/rstudio:4.4.2

# Install system dependencies
USER root
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Switch to rstudio
USER rstudio
WORKDIR /home/rstudio/project

# Copy renv infrastructure
COPY --chown=rstudio:rstudio renv.lock renv.lock
COPY --chown=rstudio:rstudio renv/activate.R renv/activate.R
COPY --chown=rstudio:rstudio renv/settings.json renv/settings.json
COPY --chown=rstudio:rstudio .Rprofile .Rprofile

# Disable renv sandbox
ENV RENV_CONFIG_SANDBOX_ENABLED FALSE

# Install renv, then cowsay, then restore packages
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')" && \
    R -e "install.packages('cowsay', repos='https://cloud.r-project.org')" && \
    R -e "renv::restore(library = '/home/rstudio/project/renv/library', prompt = FALSE)"

# Copy rest of project
COPY --chown=rstudio:rstudio . .

# Add comment for trigger# trigger rebuild
