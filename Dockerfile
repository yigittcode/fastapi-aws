# --- Aşama 1: Builder (Bağımlılıkları Yükle) ---
# uv'yi kurup bağımlılıkları yüklemek için standart python imajını kullanıyoruz
FROM python:3.12-slim AS builder

# uv'yi kur
RUN pip install uv

WORKDIR /app

# Sadece bağımlılık dosyasını kopyala
COPY pyproject.toml .

# uv kullanarak sanal bir ortam oluştur ve bağımlılıkları kur
RUN uv venv
RUN .venv/bin/uv pip sync pyproject.toml

# --- Aşama 2: Production (Son İmaj) ---
# Sadece gerekli dosyaları içeren tertemiz bir imajla başla
FROM python:3.12-slim

WORKDIR /app

# Güvenlik için 'root' olmayan bir kullanıcı oluştur
RUN groupadd --system appuser && useradd --system --group appuser appuser

# Builder aşamasından sadece kurulu bağımlılıkları (venv) kopyala
COPY --from=builder /app/.venv .venv

# Şimdi uygulama kodunu kopyala
# (main.py'nin ana dizinde olduğunu varsayıyorum)
COPY main.py .

# Sanal ortamı PATH'e ekle ki komutlar (uvicorn) bulunsun
ENV PATH="/app/.venv/bin:$PATH"

# Dosyaların sahibi olarak 'appuser'ı ata
RUN chown -R appuser:appuser /app

# 'root' yerine bu kullanıcıya geçiş yap
USER appuser

# FastAPI'nin çalışacağı port
EXPOSE 8000

# Konteyner çalıştığında uygulamayı başlat
# (main.py içindeki FastAPI objesinin adının 'app' olduğunu varsayıyorum)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]