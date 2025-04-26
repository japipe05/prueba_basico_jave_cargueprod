# Builder stage
FROM node:20-alpine AS builder
WORKDIR /app
# Copying package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install --production
# Copy the rest of the code base into the image
COPY . .
# Build the Next.js project
RUN npx next build

# Runner stage
FROM node:20-alpine
WORKDIR /app
# Copying necessary files from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the listening port
EXPOSE 3000

# Run the application
CMD ["npx", "next", "start", "-p", "3000"]