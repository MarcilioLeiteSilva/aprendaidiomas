from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import declarative_base
from app.config import settings

# Cria o engine assíncrono para conexão com o PostgreSQL
engine = create_async_engine(settings.DATABASE_URL, echo=False)

# SessionLocal gerencia as transações assíncronas do banco
SessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

# Base declarativa para os modelos do banco de dados
Base = declarative_base()

# Dependência do FastAPI para obter a sessão do banco por requisição
async def get_db():
    async with SessionLocal() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()
