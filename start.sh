#!/bin/sh
set -e

export N8N_PORT="${PORT:-${N8N_PORT:-5678}}"
export N8N_LISTEN_ADDRESS="${N8N_LISTEN_ADDRESS:-0.0.0.0}"

exec n8n start
