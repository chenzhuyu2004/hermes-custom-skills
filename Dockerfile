FROM python:trixie

# Node.js 20
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# System tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc poppler-utils libreoffice-writer \
    && rm -rf /var/lib/apt/lists/*

# Python: docx + xlsx + pdf
RUN pip install --no-cache-dir \
    python-docx defusedxml lxml \
    openpyxl \
    pypdf pdfplumber pymupdf reportlab

# Node: docx
RUN npm install -g docx
ENV NODE_PATH=/usr/lib/node_modules

WORKDIR /workspace
CMD ["sleep", "infinity"]
