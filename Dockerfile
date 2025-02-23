FROM analythium/r2u-quarto:20.04

# Install system dependencies for Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install R dependencies
RUN R -e "install.packages('reticulate')"

# Create app user and working directory
RUN addgroup --system app && adduser --system --ingroup app app
WORKDIR /home/app

# Copy both R and Python dependencies first
COPY shiny/requirements.txt ./

# Install Python packages
RUN python3 -m pip install --no-cache-dir -U pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt

# Install Jupyter kernel for Python
RUN python3 -m ipykernel install --user --name=python3

# Copy application files
COPY shiny/ ./

# Set ownership and switch user
RUN chown -R app:app /home/app
USER app

EXPOSE 8080

CMD ["quarto", "serve", "index.qmd", "--port", "8080", "--host", "0.0.0.0"]