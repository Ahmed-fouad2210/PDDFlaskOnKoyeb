# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

# Create virtual environment
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Upgrade pip and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Stage 2: Runner
FROM python:3.11-slim AS runner

WORKDIR /app

# Copy venv and app files from builder
COPY --from=builder /app/venv /app/venv
COPY app.py .

# Re-set environment variables
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV FLASK_APP=app.py

EXPOSE 8080

# Use gunicorn to serve the app
CMD ["gunicorn", "--bind", ":8080", "--workers", "2", "app:app"]
