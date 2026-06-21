import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str = "sqlite+aiosqlite:///./learnlanguages.db"
    GROQ_API_KEY: str = ""
    OPENAI_API_KEY: str = ""
    MOCK_GOOGLE_PLAY: bool = True
    GOOGLE_SERVICE_ACCOUNT_JSON: str = ""  # String contendo o JSON das credenciais ou caminho para o arquivo
    TTS_CACHE_DIR: str = "./tts_cache_files"

    class Config:
        env_file = ".env"
        extra = "ignore"

settings = Settings()

# Normaliza a URL do banco de dados para PostgreSQL assíncrono caso necessário.
# Em produção (ex: Easypanel/VPS), a DATABASE_URL injetada costuma ser "postgres://" ou "postgresql://",
# mas a biblioteca sqlalchemy (create_async_engine) requer o prefixo "postgresql+asyncpg://".
if settings.DATABASE_URL.startswith("postgres://"):
    settings.DATABASE_URL = settings.DATABASE_URL.replace("postgres://", "postgresql+asyncpg://", 1)
elif settings.DATABASE_URL.startswith("postgresql://"):
    settings.DATABASE_URL = settings.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://", 1)

# Imprime a URL de conexão com a senha mascarada para depuração fácil nos logs do Easypanel
try:
    from urllib.parse import urlparse
    parsed = urlparse(settings.DATABASE_URL)
    netloc = parsed.netloc
    if "@" in netloc:
        auth, host = netloc.split("@", 1)
        if ":" in auth:
            user, _ = auth.split(":", 1)
            netloc = f"{user}:***@{host}"
        else:
            netloc = f"{auth}:***@{host}"
    print(f"[DEBUG] DATABASE_URL de conexao configurada: {parsed.scheme}://{netloc}{parsed.path}")
except Exception as e:
    print(f"[DEBUG] Erro ao parsear DATABASE_URL para log: {e}")

# Garante que a pasta de cache do TTS exista
os.makedirs(settings.TTS_CACHE_DIR, exist_ok=True)
