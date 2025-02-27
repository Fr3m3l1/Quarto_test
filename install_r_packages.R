# Install CRAN packages
install.packages(c("shiny", "reticulate", "jsonlite", "rmarkdown", "plotly", "vegan"), repos = "http://cran.rstudio.com/")

# Install Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", repos = "http://cran.rstudio.com/")
}
BiocManager::install(c("phyloseq", "DESeq2"))
