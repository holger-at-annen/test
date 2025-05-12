#!/bin/sh
# Set default RECEIVER_EMAIL if not provided
: "${RECEIVER_EMAIL:=dummy@example.com}"

# Process the env.js.template to replace environment variables
envsubst '$RECEIVER_EMAIL' < /usr/share/nginx/html/env.js.template > /usr/share/nginx/html/env.js

# Debug: Output the generated env.js to logs
cat /usr/share/nginx/html/env.js

# Start Nginx
exec "$@"
