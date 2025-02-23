FROM python:3.11-slim

# Install Quarto and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    wget \
    && wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-amd64.deb -O quarto.deb \
    && dpkg -i quarto.deb \
    && rm quarto.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/bin/bash", "render.sh"]