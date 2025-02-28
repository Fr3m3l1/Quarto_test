# Use R base image from Rocker
FROM rocker/r-ver:4.2.2

# Set environment variables
ENV R_LIBS_USER=/usr/local/lib/R/site-library
ENV RETICULATE_PYTHON=/usr/bin/python3

# Install system dependencies and Python
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 python3-pip python3-venv \
    wget \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libpcre2-dev \
    liblzma-dev \
    libbz2-dev \
    && rm -rf /var/lib/apt/lists/*

# Update pip and setuptools
RUN pip3 install --upgrade pip setuptools

# Install Python packages
RUN pip3 install --no-cache-dir shiny rpy2 numpy pandas

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-amd64.deb && \
    dpkg -i quarto-1.6.42-linux-amd64.deb && \
    rm quarto-1.6.42-linux-amd64.deb

# Install R packages (CRAN + Bioconductor)
RUN R -e "install.packages(c('shiny', 'ggplot2', 'vegan', 'plotly', 'rmarkdown', 'jsonlite'), repos='https://cloud.r-project.org/', Ncpus=4)" && \
    R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos='https://cloud.r-project.org/'); BiocManager::install('DESeq2', Ncpus=4)"

# Copy application files
COPY shiny/app.qmd /srv/shiny-server/
COPY shiny/ms-project_Excel_output.csv /srv/shiny-server/

# Set working directory
WORKDIR /srv/shiny-server/

# Expose port
EXPOSE 8080

# Start application
CMD ["quarto", "serve", "app.qmd", "--no-browser", "--port", "8080", "--host", "0.0.0.0"]