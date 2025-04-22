# Stage 1: Build dependencies
FROM python:3.10-slim AS builder

WORKDIR /app

# Copy requirements and install them into /install
COPY requirements.txt .
RUN apt-get update && apt-get install -y libgl1-mesa-glx && \
    pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt

# Stage 2: Final runtime image
FROM python:3.10-slim

WORKDIR /app

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local

# Copy the rest of the application
COPY . .

# Make port 8080 accessible
EXPOSE 8080

# Command to run app using gunicorn (better for production)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
