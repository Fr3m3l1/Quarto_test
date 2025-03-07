# Use the official Quarto image which includes R, Pandoc, and Quarto
FROM quarto-dev/quarto:latest

# Install required R packages
RUN R -e "install.packages(c('flexdashboard', 'shiny', 'ggplot2', 'dplyr', 'palmerpenguins', 'gridExtra', 'knitr', 'rmarkdown'), repos='https://cloud.r-project.org')"

# Set the working directory
WORKDIR /project

# Copy your Quarto document into the container
COPY r_only/r_only.qmd .

# Expose the port used by quarto serve (default: 4242)
EXPOSE 8080

# Run the Quarto document with the Shiny runtime
CMD ["quarto", "serve", "r_only.qmd", "--no-browser", "--port", "8080", "--allow-remote"]
