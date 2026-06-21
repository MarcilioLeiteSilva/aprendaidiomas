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

# Garante que a pasta de cache do TTS exista
os.makedirs(settings.TTS_CACHE_DIR, exist_ok=True)
