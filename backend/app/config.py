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

def normalize_db_url(url: str) -> str:
    if not (url.startswith("postgres://") or url.startswith("postgresql://")):
        return url
    try:
        # Se a senha contiver caracteres especiais como '@' ou '#', o parsing padrão do python/sqlalchemy falha.
        # Por isso fazemos um parse customizado dividindo pelo último '@' que separa as credenciais do host.
        if url.startswith("postgres://"):
            remaining = url[len("postgres://"):]
        else:
            remaining = url[len("postgresql://"):]
            
        if "@" in remaining:
            user_pass, host_port_db = remaining.rsplit("@", 1)
            
            # Divide host/porta e banco de dados
            if "/" in host_port_db:
                host_port, db = host_port_db.split("/", 1)
                path = "/" + db
            else:
                host_port = host_port_db
                path = ""
                
            # Codifica (percent-encode) usuário e senha para evitar erros de sintaxe na URL
            import urllib.parse
            if ":" in user_pass:
                user, password = user_pass.split(":", 1)
                user = urllib.parse.quote_plus(user)
                password = urllib.parse.quote_plus(password)
                user_pass_encoded = f"{user}:{password}@"
            else:
                user_pass_encoded = f"{urllib.parse.quote_plus(user_pass)}@"
        else:
            user_pass_encoded = ""
            if "/" in remaining:
                host_port, db = remaining.split("/", 1)
                path = "/" + db
            else:
                host_port = remaining
                path = ""
                
        return f"postgresql+asyncpg://{user_pass_encoded}{host_port}{path}"
    except Exception as e:
        # Fallback simples
        if url.startswith("postgres://"):
            return url.replace("postgres://", "postgresql+asyncpg://", 1)
        elif url.startswith("postgresql://"):
            return url.replace("postgresql://", "postgresql+asyncpg://", 1)
        return url

# Normaliza a URL do banco de dados para PostgreSQL assíncrono e corrige caracteres especiais na senha
settings.DATABASE_URL = normalize_db_url(settings.DATABASE_URL)

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
