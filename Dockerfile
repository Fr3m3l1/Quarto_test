# Use a Python slim base image.
FROM python:3.9-slim

# Install system dependencies: R, wget, and others.
RUN apt-get update && apt-get install -y \
    r-base \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install required Python packages: shiny for the Shiny app and rpy2 for R integration.
RUN pip install shiny rpy2

# Download and install Quarto (adjust the version if needed).
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-amd64.deb && \
    dpkg -i quarto-1.6.42-linux-amd64.deb && \
    rm quarto-1.6.42-linux-amd64.deb

RUN R -e "install.packages(c('shiny', 'reticulate', 'jsonlite', 'rmarkdown'), repos='http://cran.rstudio.com/')"

# Copy the Quarto file into the container.
COPY shiny/app.qmd /srv/shiny-server/

# Set the working directory.
WORKDIR /srv/shiny-server/

# Expose port 8080.
EXPOSE 8080

# Start the Quarto Shiny app on port 8080.
CMD ["quarto", "preview", "app.qmd", "--no-browser", "--port", "8080", "--host", "0.0.0.0"]
