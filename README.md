# Railway n8n Docker Project

Project này deploy n8n lên Railway bằng Docker, dùng biến môi trường, webhook public và persistent storage.

## Files

- `Dockerfile`: chạy image `n8nio/n8n`.
- `railway.toml`: cấu hình build/deploy cho Railway.
- `docker-compose.yml`: chạy local với volume `n8n_data`.
- `.env.example`: danh sách biến môi trường cần set.
- `.env.local.example`: biến môi trường để chạy local qua HTTP.
- `workflows/zalo-webhook-example.json`: workflow mẫu nhận webhook Zalo.

## Chạy local

```bash
cp .env.local.example .env
docker compose up --build
```

Mở n8n tại:

```text
http://localhost:5678
```

Khi chạy local, nếu muốn test webhook bằng tunnel public, đổi:

```env
N8N_HOST=your-public-domain
WEBHOOK_URL=https://your-public-domain/
N8N_EDITOR_BASE_URL=https://your-public-domain/
```

## Deploy lên Railway

1. Tạo project Railway từ repo này.
2. Deploy bằng Dockerfile.
3. Tạo public domain cho service.
4. Thêm persistent volume và mount vào:

```text
/home/node/.n8n
```

5. Set biến môi trường trên Railway.

Ví dụ khi Railway public domain là `my-n8n.up.railway.app`:

```env
N8N_HOST=my-n8n.up.railway.app
WEBHOOK_URL=https://my-n8n.up.railway.app/
N8N_EDITOR_BASE_URL=https://my-n8n.up.railway.app/
N8N_PROTOCOL=https
N8N_PORT=5678
N8N_LISTEN_ADDRESS=0.0.0.0
GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
TZ=Asia/Ho_Chi_Minh
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=change-this-password
N8N_ENCRYPTION_KEY=replace-with-a-long-random-secret
N8N_SECURE_COOKIE=true
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
N8N_DIAGNOSTICS_ENABLED=false
```

`N8N_ENCRYPTION_KEY` phải được giữ cố định. Nếu đổi key sau khi đã tạo credentials, n8n có thể không đọc được credentials cũ.

## Webhook public

Sau khi set `WEBHOOK_URL`, webhook production của n8n sẽ có dạng:

```text
https://my-n8n.up.railway.app/webhook/<path>
```

Webhook test trong editor thường có dạng:

```text
https://my-n8n.up.railway.app/webhook-test/<path>
```

Trong n8n, tạo workflow có node `Webhook`, chọn method/path, activate workflow, rồi dùng production URL `/webhook/...` cho hệ thống bên ngoài.

Repo cũng có workflow mẫu tại:

```text
workflows/zalo-webhook-example.json
```

Import workflow này vào n8n, activate workflow, rồi dùng:

```text
https://my-n8n.up.railway.app/webhook/zalo
```

## Zalo API

Project đã chuẩn bị biến môi trường cho Zalo:

```env
ZALO_APP_ID=
ZALO_APP_SECRET=
ZALO_OA_ID=
ZALO_ACCESS_TOKEN=
ZALO_REFRESH_TOKEN=
ZALO_WEBHOOK_VERIFY_TOKEN=
```

Cách dùng trong n8n:

- Dùng node `HTTP Request`.
- API base thường là API của Zalo Official Account hoặc Zalo Open API theo use case.
- Lưu token trong Railway Variables, không hard-code trong workflow.
- Trong n8n expression, đọc biến bằng:

```text
{{$env.ZALO_ACCESS_TOKEN}}
```

Ví dụ header:

```text
access_token: {{$env.ZALO_ACCESS_TOKEN}}
```

Nếu Zalo gọi webhook về n8n, dùng production webhook URL:

```text
https://my-n8n.up.railway.app/webhook/zalo
```

## Persistent storage

n8n lưu dữ liệu local tại:

```text
/home/node/.n8n
```

Trên Railway cần tạo Volume mount đúng path này để giữ:

- SQLite database mặc định.
- Credentials metadata.
- n8n config.

Với production lớn hơn, nên dùng Postgres thay SQLite. Khi đó có thể bổ sung các biến:

```env
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=
DB_POSTGRESDB_USER=
DB_POSTGRESDB_PASSWORD=
```
