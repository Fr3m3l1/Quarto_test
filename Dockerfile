FROM analythium/r2u-quarto:20.04

RUN apt-get update && apt-get install -y texlive-latex-base lmodern texlive-latex-extra

# Erstelle einen nicht-root Benutzer
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app

# Kopiere die Datei 'r_only.qmd' direkt ins Arbeitsverzeichnis
COPY r_only/r_only.qmd /home/app/r_only.qmd

# Installiere die benoetigten R-Pakete
RUN R -e "install.packages(c('flexdashboard', 'shiny', 'ggplot2', 'dplyr', 'vegan', 'DT', 'reshape2', 'gridExtra', 'tinytex'))"
RUN R -e "install.packages('rmarkdown', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('xfun', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('htmltools', repos='https://cloud.r-project.org')"

RUN R -e "update.packages(ask = FALSE, repos = 'https://cloud.r-project.org')"

# Aendere den Besitzer des Arbeitsverzeichnisses
RUN chown app:app -R /home/app

USER app

EXPOSE 8080

# Starte Quarto und serve die Datei
CMD ["quarto", "serve", "r_only.qmd", "--port", "8080", "--host", "0.0.0.0"]
