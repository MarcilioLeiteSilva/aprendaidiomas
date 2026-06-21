import logging
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, Header, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models import User, DailyUsage
from app.schemas import UserProfileResponse
from app.config import settings

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/users", tags=["Users"])

async def get_or_create_user(
    db: AsyncSession,
    device_id: str,
    app_language: str
) -> User:
    """
    Busca o usuário pelo ID do dispositivo. Se não existir, registra no banco.
    Também verifica e expira o status premium caso o prazo tenha vencido.
    """
    stmt = select(User).where(User.device_id == device_id)
    result = await db.execute(stmt)
    user = result.scalars().first()

    if not user:
        # Registra novo dispositivo
        user = User(
            device_id=device_id,
            app_language=app_language,
            is_premium=settings.MOCK_GOOGLE_PLAY
        )
        db.add(user)
        # Flush para obter o ID gerado pelo Postgres antes de commitar
        await db.flush()
        logger.info(f"Dispositivo registrado com sucesso: {device_id} ({app_language})")
    else:
        # Se mudou o idioma do app, atualiza
        if user.app_language != app_language:
            user.app_language = app_language
            db.add(user)

    # Se MOCK_GOOGLE_PLAY estiver ativado, garante status Premium para testes
    if settings.MOCK_GOOGLE_PLAY and not user.is_premium:
        user.is_premium = True
        db.add(user)

    # Verifica expiração de assinatura Pro
    if user.is_premium and user.premium_until:
        now = datetime.now(timezone.utc)
        user_exp = user.premium_until
        
        # Garante comparação com timezone
        if user_exp.tzinfo is None:
            user_exp = user_exp.replace(tzinfo=timezone.utc)
            
        if user_exp < now:
            user.is_premium = False
            db.add(user)
            logger.info(f"Assinatura Pro expirada para o dispositivo: {device_id}")

    return user

async def get_today_usage(
    db: AsyncSession,
    user_id
) -> int:
    """
    Obtém a quantidade de mensagens enviadas hoje pelo usuário.
    """
    stmt = select(DailyUsage).where(
        DailyUsage.user_id == user_id,
        DailyUsage.date == datetime.now().date()
    )
    result = await db.execute(stmt)
    usage = result.scalars().first()
    return usage.message_count if usage else 0

@router.get("/profile", response_model=UserProfileResponse)
async def get_profile(
    x_device_uuid: str = Header(..., alias="X-Device-UUID"),
    x_app_language: str = Header(..., alias="X-App-Language"),
    db: AsyncSession = Depends(get_db)
):
    if not x_device_uuid or not x_app_language:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cabeçalhos X-Device-UUID e X-App-Language são obrigatórios"
        )
        
    user = await get_or_create_user(db, x_device_uuid, x_app_language)
    used_today = await get_today_usage(db, user.id)
    
    limit_reached = (not user.is_premium) and (used_today >= 5)
    
    return UserProfileResponse(
        device_id=user.device_id,
        app_language=user.app_language,
        is_premium=user.is_premium,
        premium_until=user.premium_until,
        free_messages_used_today=used_today,
        limit_reached=limit_reached
    )
