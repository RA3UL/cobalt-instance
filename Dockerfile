# Cobalt API - Self-hosted YouTube/media downloader
# Official image from imputnet/cobalt
FROM ghcr.io/imputnet/cobalt:latest

# Railway sets $PORT (usually 8080). We tell Cobalt the public URL and
# forward the port using socat so Cobalt listens on Railway's PORT instead
# of its hardcoded 9000.
RUN apt-get update && apt-get install -y --no-install-recommends socat ca-certificates curl && rm -rf /var/lib/apt/lists/*

ENV API_URL=http://localhost:8080/

# Start socat to forward $PORT (Railway) -> 9000 (cobalt internal)
# Then run cobalt in the foreground
CMD ["sh", "-c", "socat TCP-LISTEN:${PORT:-8080},reuseaddr,fork TCP:127.0.0.1:9000 & exec node src/cobalt"]
