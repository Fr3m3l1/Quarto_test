FROM analythium/r2u-quarto:20.04

# Install system dependencies with Python development files
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install R dependencies
RUN R -e "install.packages('reticulate')"

# Create app user and working directory
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app

# Create Python virtual environment
RUN python3 -m venv /home/app/venv
ENV PATH="/home/app/venv/bin:$PATH"

# Copy requirements first for better caching
COPY shiny/requirements.txt ./

# Install Python packages in virtual environment
RUN python3 -m pip install --no-cache-dir -U pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt

# Configure reticulate to use the virtual environment
RUN R -e "reticulate::use_virtualenv('/home/app/venv', required=TRUE)"

# Copy application files
COPY shiny/ ./

RUN chown -R app:app /home/app
USER app

# Verify Python configuration
RUN python3 --version && \
    R -e "reticulate::py_config()"

EXPOSE 8080
CMD ["quarto", "serve", "index.qmd", "--port", "8080", "--host", "0.0.0.0"]