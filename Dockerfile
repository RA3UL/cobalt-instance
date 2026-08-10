# Cobalt API - Self-hosted YouTube/media downloader
# Official image from imputnet/cobalt
FROM ghcr.io/imputnet/cobalt:latest

# Cobalt listens on port 9000 by default. Railway expects the app to bind
# to the port in the PORT env variable (usually 8080). We expose the
# Cobalt internal port as 9000 in the image and rely on Railway's runtime
# to forward $PORT -> container. Since the cobalt binary is fixed, we
# simply expose 9000 and let Railway's network infrastructure handle it.
EXPOSE 9000
EXPOSE 8080

ENV API_URL=http://localhost:9000/
