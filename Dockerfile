# Cobalt API - Self-hosted YouTube/media downloader
# Official image from imputnet/cobalt, fronted by an Express proxy that
# binds Railway's $PORT and forwards traffic to the Cobalt container on 9000.
FROM node:22-bookworm-slim AS proxy-builder
WORKDIR /proxy
COPY package.json proxy.js ./
RUN npm install --omit=dev

FROM ghcr.io/imputnet/cobalt:latest AS cobalt
# Cobalt listens on 9000 inside its own image; we keep it that way.

# Final image: copy the proxy into the cobalt image and run both
FROM ghcr.io/imputnet/cobalt:latest
WORKDIR /proxy
COPY --from=proxy-builder /proxy /proxy
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*

# Start Cobalt in the background, then run the proxy in the foreground
# Cobalt uses port 9000, proxy uses $PORT (Railway sets this to 8080 typically)
ENV COBALT_URL=http://localhost:9000
CMD ["sh", "-c", "node src/cobalt & sleep 3 && node /proxy/proxy.js"]
