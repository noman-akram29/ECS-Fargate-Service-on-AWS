# syntax=docker/dockerfile:1.6
# Pin to an exact Node.js release for reproducible and predictable builds.
# Avoids unexpected breaking changes from floating tags like `node:20`.
FROM node:20.19.1-bookworm-slim AS builder
WORKDIR /app
# Copy dependencies first for better layer caching.
COPY package.json package-lock.json ./
# Use BuildKit secrets so NPM_TOKEN never persists in image layers/history.
RUN --mount=type=secret,id=npm_token \
 --mount=type=cache,target=/root/.npm \
 NPM_TOKEN="$(cat /run/secrets/npm_token)" && \
 echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc && \
 npm ci && \
 rm -f .npmrc
COPY . .
RUN npm run build && npm prune --omit=dev
FROM node:20.19.1-bookworm-slim AS runtime
RUN apt-get update && \
    apt-get install -y --no-install-recommends tini wget && \
    rm -rf /var/lib/apt/lists/*
    
LABEL org.opencontainers.image.title="payment-webhook-service" \
 org.opencontainers.image.description="Production Node.js payment webhook processor" \
 org.opencontainers.image.vendor="ILI Digital" \
 org.opencontainers.image.licenses="UNLICENSED"
WORKDIR /app
# Run as a non-root user with a fixed UID/GID for container hardening.
RUN groupadd --gid 10001 appgroup && \
 useradd --uid 10001 --gid appgroup --shell /usr/sbin/nologin --no-create-home appuser
# Copy only runtime artifacts.
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package.json ./package.json
USER appuser
EXPOSE 3000
ENV NODE_ENV=production \
 PORT=3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
 CMD wget -qO- --tries=1 http://localhost:3000/health || exit 1
# tini forwards SIGTERM correctly so Node shuts down gracefully in containers.
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "dist/server.js"]
