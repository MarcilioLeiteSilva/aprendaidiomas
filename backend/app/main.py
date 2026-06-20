import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base
from app.routers import users, ai, billing

# Configuração de logs
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Ações de Startup: Sincroniza tabelas no PostgreSQL automaticamente
    logger.info("Inicializando conexão com o banco e sincronizando tabelas...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    logger.info("Tabelas sincronizadas com sucesso.")
    yield
    # Ações de Shutdown (opcional)
    logger.info("Encerrando aplicação...")

app = FastAPI(
    title="LearnLanguages Backend API",
    description="Servidor de IA, Controle de Uso e Faturamento para Aplicativos de Idiomas",
    version="1.0.0",
    lifespan=lifespan
)

# Permite chamadas CORS de qualquer origem para facilitar testes com simuladores mobile
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclui os roteadores das rotas da API
app.include_router(users.router, prefix="/api/v1")
app.include_router(ai.router, prefix="/api/v1")
app.include_router(billing.router, prefix="/api/v1")

@app.get("/")
async def root():
    return {
        "app": "LearnLanguages Backend API",
        "status": "online",
        "version": "1.0.0"
    }
