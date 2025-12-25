# syntax=docker/dockerfile:1.7

FROM python:3.13-slim AS builder

# Get uv without pip-installing it
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1

# 1) Install deps first (better Docker cache)
COPY pyproject.toml uv.lock ./

# Use --no-install-project because the source code isn't copied yet
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# 2) Copy application code
COPY app ./app

# 3) Install the project
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev


FROM python:3.13-slim AS runtime

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

# Create a non-root user
RUN useradd -m -u 10001 appuser

# Copy only what we need at runtime
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/app /app/app

# Ensure correct permissions
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
