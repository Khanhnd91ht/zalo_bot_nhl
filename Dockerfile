FROM docker.n8n.io/n8nio/n8n:latest

ENV N8N_LISTEN_ADDRESS=0.0.0.0 \
    N8N_PROTOCOL=http \
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
    N8N_SECURE_COOKIE=false

EXPOSE 5678

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT []
CMD ["/bin/sh", "/start.sh"]
