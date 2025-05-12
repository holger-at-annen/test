FROM node:18-alpine AS builder

# Install TailwindCSS and build CSS
WORKDIR /app
COPY package.json .
RUN npm install
COPY src/input.css src/
COPY tailwind.config.js .
RUN npm run build:css

FROM nginx:alpine

# Copy built CSS and HTML
COPY --from=builder /app/dist/styles.css /usr/share/nginx/html/styles.css
COPY src/index.html /usr/share/nginx/html/index.html

# Create env.js template
RUN echo 'window.ENV = { RECEIVER_EMAIL: "$RECEIVER_EMAIL" };' > /usr/share/nginx/html/env.js.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 80
EXPOSE 80

# Use custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
