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

# Garante que a pasta de cache do TTS exista
os.makedirs(settings.TTS_CACHE_DIR, exist_ok=True)
