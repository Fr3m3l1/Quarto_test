# Verwende ein R-Basisimage von Rocker (R-Version anpassen, wenn noetig)
FROM rocker/r-ver:4.2.2

# Umgebungsvariable fuer den R Library-Pfad setzen
ENV R_LIBS_USER=/usr/local/lib/R/site-library

# Installiere System-Abhaengigkeiten, Python und notwendige Pakete
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    wget \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Installiere die benoetigten Python-Pakete ohne Cache
RUN pip3 install --no-cache-dir shiny rpy2 numpy

# Lade Quarto herunter und installiere es
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.42/quarto-1.6.42-linux-amd64.deb && \
    dpkg -i quarto-1.6.42-linux-amd64.deb && \
    rm quarto-1.6.42-linux-amd64.deb

# Installiere die benoetigten R-Pakete aus CRAN und Bioconductor
RUN R -e "install.packages(c('shiny', 'reticulate', 'jsonlite', 'rmarkdown', 'plotly', 'vegan'), repos='http://cran.rstudio.com/', Ncpus=4)" && \
    R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager', repos='http://cran.rstudio.com/'); BiocManager::install(c('phyloseq', 'DESeq2'), Ncpus=4)"

# Kopiere den Quarto-File und weitere Dateien in das Image
COPY shiny/app.qmd /srv/shiny-server/
COPY shiny/ms-project_Excel_output.csv /srv/shiny-server/

# Setze das Arbeitsverzeichnis
WORKDIR /srv/shiny-server/

# Exponiere den Port 8080
EXPOSE 8080

# Starte die Quarto Shiny-App
CMD ["quarto", "serve", "app.qmd", "--no-browser", "--port", "8080", "--host", "0.0.0.0"]
