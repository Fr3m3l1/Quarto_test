# Use the official Rocker Shiny image as the base
FROM rocker/shiny:latest

# Install system dependencies: Python, pip, wget (for downloading Quarto)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('shiny', 'reticulate'), repos='http://cran.rstudio.com/')"

# Install rpy2 in Python
RUN pip3 install rpy2

# Download and install Quarto (adjust the version as needed)
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.313/quarto-1.2.313-linux-amd64.deb && \
    dpkg -i quarto-1.2.313-linux-amd64.deb && \
    rm quarto-1.2.313-linux-amd64.deb

# Copy the Quarto file into the container
COPY app.qmd /srv/shiny-server/

# Set the working directory
WORKDIR /srv/shiny-server/

# Expose the Shiny port
EXPOSE 8080

# Start the Quarto Shiny app (the --no-browser flag prevents auto-opening a browser)
CMD ["quarto", "preview", "app.qmd", "--no-browser", "--port", "8080", "--host", "0.0.0.0"]
