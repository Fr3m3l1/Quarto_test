FROM analythium/r2u-quarto:20.04

# Create a non-root user
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app

# Copy only the r_only.qmd file directly into /home/app
COPY r_only/r_only.qmd /home/app/r_only.qmd

# Install required R packages (if needed)
RUN R -e "install.packages(c('flexdashboard', 'shiny', 'ggplot2', 'dplyr', 'palmerpenguins', 'gridExtra', 'knitr', 'rmarkdown'), repos='https://cloud.r-project.org')"

RUN chown app:app -R /home/app

USER app

EXPOSE 8080

# Now, the file is directly in the working directory
CMD ["quarto", "serve", "r_only.qmd", "--port", "8080", "--host", "0.0.0.0"]