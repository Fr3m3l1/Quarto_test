FROM analythium/r2u-quarto:20.04

# Install Python and pandas
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    && pip3 install pandas \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -c "import pandas"

# Create app user and set up directory
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app
COPY shiny .
RUN chown app:app -R /home/app
USER app

EXPOSE 8080

CMD ["quarto", "serve", "index.qmd", "--port", "8080", "--host", "0.0.0.0"]