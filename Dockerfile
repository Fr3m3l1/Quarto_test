FROM analythium/r2u-quarto:20.04

# System dependencies + Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# R dependencies
RUN R -e "install.packages('reticulate')"

# Create app user with home directory
RUN addgroup --system app && \
    adduser --system --ingroup app --home /home/app app

# Create cache directory with proper permissions
RUN mkdir -p /home/app/.cache/deno && \
    chown -R app:app /home/app

WORKDIR /home/app

# Create Python virtual environment
RUN python3 -m venv /home/app/venv && \
    chown -R app:app /home/app/venv

ENV PATH="/home/app/venv/bin:$PATH" \
    VIRTUAL_ENV="/home/app/venv" \
    DENO_DIR="/home/app/.cache/deno"

# Copy requirements and install Python packages
COPY --chown=app:app shiny/requirements.txt .
RUN pip install --no-cache-dir -U pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Configure reticulate
RUN R -e "reticulate::use_virtualenv('$VIRTUAL_ENV', required=TRUE)"

# Copy app files
COPY --chown=app:app shiny/ .

# Final verification
USER app
RUN mkdir -p /home/app/.cache/deno && \
    touch /home/app/.cache/deno/test-file && \
    rm /home/app/.cache/deno/test-file

EXPOSE 8080
CMD ["quarto", "serve", "index.qmd", "--port", "8080", "--host", "0.0.0.0"]