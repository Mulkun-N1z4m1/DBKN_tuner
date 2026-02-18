# ============================================================================
# DBKN Tuner — Docker Build
# Multi-stage build for production deployment
# ============================================================================

# --- Stage 1: Build ---
FROM python:3.12-slim AS builder

WORKDIR /build

COPY pyproject.toml ./
COPY src/ ./src/

RUN pip install --no-cache-dir --prefix=/install .

# --- Stage 2: Production ---
FROM python:3.12-slim AS production

# Security: Non-root user
RUN groupadd -r dbkn && useradd -r -g dbkn -d /app -s /usr/sbin/nologin dbkn

# Install from builder
COPY --from=builder /install /usr/local

# Application files
WORKDIR /app
COPY config.yaml ./
COPY samples/ ./samples/

# Create required directories
RUN mkdir -p /app/output/logs /app/input /app/secrets \
    && chown -R dbkn:dbkn /app

# Security: Read-only root filesystem support
# Mount output, input, and secrets as volumes
VOLUME ["/app/output", "/app/input", "/app/secrets"]

# Environment
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DBKN_LM_STUDIO_URL=http://host.docker.internal:1234/v1

# Switch to non-root user
USER dbkn

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python -c "from dbkn_tuner.engine.client import LMStudioClient; from dbkn_tuner.config_loader import load_config; c = load_config(); cl = LMStudioClient(c.lm_studio); exit(0 if cl.health_check() else 1)"

# Default command
ENTRYPOINT ["dbkn-tuner"]
CMD ["--help"]

# Labels
LABEL maintainer="DBKN Tuner Team" \
      description="AI-Powered RDBMS Advisory Application" \
      version="1.0.0"
