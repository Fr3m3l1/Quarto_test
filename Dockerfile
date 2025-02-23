FROM python:3.11-slim

# Install R and Quarto dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg \
    ca-certificates \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && echo "deb https://cloud.r-project.org/bin/linux/debian bullseye-cran40/" > /etc/apt/sources.list.d/r.list \
    && apt-get update \
    && apt-get install -y r-base r-base-dev pandoc pandoc-citeproc \
    && wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-amd64.deb -O quarto.deb \
    && dpkg -i quarto.deb \
    && rm quarto.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install essential R packages
RUN Rscript -e "install.packages('knitr', repos='https://cran.rstudio.com/')"
RUN Rscript -e "install.packages('reticulate', repos='https://cran.rstudio.com/')"


WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/bin/bash", "render.sh"]