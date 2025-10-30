# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Production stage
FROM node:20-alpine
ENV NODE_ENV=production
WORKDIR /app

# Create a non-root user
RUN addgroup -S nodejs && \
    adduser -S expressuser -G nodejs && \
    chown -R expressuser:nodejs /app

# Copy only necessary files from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=expressuser:nodejs . .

# Switch to non-root user
USER expressuser

# Expose the port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
