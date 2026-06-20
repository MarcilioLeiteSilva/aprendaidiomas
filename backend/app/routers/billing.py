import logging
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, Header, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models import Subscription
from app.routers.users import get_or_create_user
from app.schemas import PurchaseVerifyRequest, PurchaseVerifyResponse
from app.services.google_play import GooglePlayService

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/billing", tags=["Billing & Payments"])

@router.post("/verify-purchase", response_model=PurchaseVerifyResponse)
async def verify_purchase(
    payload: PurchaseVerifyRequest,
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
    
    # Chama o serviço para verificar com a Google Play
    success, message, expires_at = GooglePlayService.verify_subscription(
        package_name=payload.package_name,
        product_id=payload.product_id,
        purchase_token=payload.purchase_token
    )
    
    # Busca se já existe essa assinatura cadastrada
    stmt = select(Subscription).where(Subscription.purchase_token == payload.purchase_token)
    result = await db.execute(stmt)
    sub = result.scalars().first()
    
    if success:
        # Atualiza status do usuário no banco
        user.is_premium = True
        user.premium_until = expires_at
        db.add(user)
        
        # Cria ou atualiza o registro de assinatura
        if not sub:
            sub = Subscription(
                user_id=user.id,
                purchase_token=payload.purchase_token,
                product_id=payload.product_id,
                status="active",
                expires_at=expires_at
            )
        else:
            sub.status = "active"
            sub.expires_at = expires_at
            sub.updated_at = datetime.now(timezone.utc)
            
        db.add(sub)
        await db.flush()
        
        logger.info(f"Compra validada com sucesso! Premium ativado para o dispositivo: {x_device_uuid} até {expires_at}")
        return PurchaseVerifyResponse(
            success=True,
            message=message,
            is_premium=True,
            premium_until=expires_at
        )
    else:
        # Se a validação falhou mas a API retornou que expirou no passado
        if expires_at:
            user.is_premium = False
            user.premium_until = expires_at
            db.add(user)
            
            if sub:
                sub.status = "expired"
                sub.expires_at = expires_at
                db.add(sub)
            await db.flush()
            
        logger.warning(f"Falha na validação do recibo para o dispositivo {x_device_uuid}: {message}")
        return PurchaseVerifyResponse(
            success=False,
            message=message,
            is_premium=user.is_premium,
            premium_until=user.premium_until
        )
