# Cobalt API - Self-hosted YouTube/media downloader
# Official image from imputnet/cobalt
FROM ghcr.io/imputnet/cobalt:latest

# Cobalt listens on port 9000 by default
EXPOSE 9000

# Default Cobalt config has CORS enabled for public use.
# For personal use, we may want to restrict it later.
ENV API_URL=http://localhost:9000/
