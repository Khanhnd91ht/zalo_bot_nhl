FROM docker.n8n.io/n8nio/n8n:latest

ENV N8N_LISTEN_ADDRESS=0.0.0.0 \
    N8N_PROTOCOL=http \
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
    N8N_SECURE_COOKIE=false

EXPOSE 5678

CMD ["sh", "-c", "export N8N_PORT=${PORT:-${N8N_PORT:-5678}} && exec n8n start"]
