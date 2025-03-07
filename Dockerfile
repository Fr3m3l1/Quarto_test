# Use the official Quarto image which includes R, Pandoc, and Quarto
FROM analythium/r2u-quarto:20.04

# Create a non-root user for security
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app

COPY . .

# Adjust file ownership
RUN chown app:app -R /home/app

# Install required R packages
RUN R -e "install.packages(c('flexdashboard', 'shiny', 'ggplot2', 'dplyr', 'palmerpenguins', 'gridExtra', 'knitr', 'rmarkdown'), repos='https://cloud.r-project.org')"

USER app
# Set the working directory
WORKDIR /project

# Copy your Quarto document into the container
COPY r_only/r_only.qmd .

# Expose the port used by quarto serve (default: 4242)
EXPOSE 8080

# Run the Quarto document with the Shiny runtime
CMD ["quarto", "serve", "r_only.qmd", "--port", "8080", "--host", "0.0.0.0"]
