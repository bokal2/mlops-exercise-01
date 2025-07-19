# Stage 1: Export requirements with Poetry
FROM python:3.12-slim AS requirements

# Install Poetry
RUN pip install poetry==1.7.1

WORKDIR /app

# Copy Poetry files
COPY pyproject.toml poetry.lock* ./

# Avoid virtualenv creation
RUN poetry config virtualenvs.create false

# Export requirements including dev dependencies
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes --with dev

# Stage 2: Development environment
FROM python:3.12-slim

# Set environment variables for Python and pip
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies including curl for healthcheck
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements from previous stage
COPY --from=requirements /app/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose port
EXPOSE 8000

# Set development environment
ENV ENVIRONMENT=development

# Default command to run the app with reload for development
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload", "--log-level", "debug"]
