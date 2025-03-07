FROM analythium/r2u-quarto:20.04

# Erstelle einen nicht-root Benutzer
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app

# Kopiere den Inhalt des r_only Ordners in das Image
COPY r_only /home/app/r_only

# Installiere benoetigte R-Pakete (falls nicht bereits vorhanden)
RUN R -e "install.packages(c('flexdashboard', 'shiny', 'ggplot2', 'dplyr', 'palmerpenguins', 'gridExtra', 'knitr', 'rmarkdown'), repos='https://cloud.r-project.org')"

# Setze die Besitzrechte
RUN chown app:app -R /home/app

USER app

# Oeffne den Port 8080
EXPOSE 8080

# Starte die Quarto App, die die Datei r_only.qmd im r_only Ordner rendert
CMD ["quarto", "serve", "r_only/r_only.qmd", "--port", "8080", "--host", "0.0.0.0"]
