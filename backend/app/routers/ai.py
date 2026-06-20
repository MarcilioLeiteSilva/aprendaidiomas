import logging
import os
from datetime import datetime
from fastapi import APIRouter, Depends, Header, HTTPException, status
from fastapi.responses import FileResponse
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import get_db
from app.models import DailyUsage
from app.routers.users import get_or_create_user, get_today_usage
from app.schemas import AiChatRequest, AiChatResponse, GrammarRequest, GrammarResponse, TtsRequest
from app.services.ai_service import AiService

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/ai", tags=["AI Integration"])

async def increment_usage(db: AsyncSession, user_id) -> int:
    """
    Incrementa a contagem de mensagens gratuitas enviadas hoje pelo usuário.
    """
    today = datetime.now().date()
    stmt = select(DailyUsage).where(
        DailyUsage.user_id == user_id,
        DailyUsage.date == today
    )
    result = await db.execute(stmt)
    usage = result.scalars().first()

    if not usage:
        usage = DailyUsage(user_id=user_id, date=today, message_count=1)
        db.add(usage)
    else:
        usage.message_count += 1
        db.add(usage)
        
    await db.flush()
    return usage.message_count

@router.post("/chat", response_model=AiChatResponse)
async def chat_conversation(
    payload: AiChatRequest,
    x_device_uuid: str = Header(..., alias="X-Device-UUID"),
    x_app_language: str = Header(..., alias="X-App-Language"),
    db: AsyncSession = Depends(get_db)
):
    user = await get_or_create_user(db, x_device_uuid, x_app_language)
    
    # Se não for Pro, verifica limite
    if not user.is_premium:
        used_today = await get_today_usage(db, user.id)
        if used_today >= 5:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Limite diário de 5 mensagens atingido. Assine o Pro para conversas ilimitadas!"
            )
            
    try:
        # Obtém o perfil do usuário atual do SQLite (nome) ou usa "Estudante"
        user_name = "Estudante"  # O nome é enviado via histórico se necessário, ou podemos usar Estudante por padrão
        
        # Chama a API de IA do Groq
        response = await AiService.get_conversation_response(
            app_language=x_app_language,
            topic_title=payload.topic_title,
            history=payload.history,
            tutor_name=payload.tutor_name,
            is_tutor_male=payload.is_tutor_male,
            selected_level=payload.selected_level,
            user_name=user_name
        )
        
        # Se o usuário não for Pro, computa a mensagem gasta
        if not user.is_premium:
            await increment_usage(db, user.id)
            
        return response
        
    except Exception as e:
        logger.error(f"Erro no chat proxy: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro interno de IA: {str(e)}"
        )

@router.post("/grammar", response_model=GrammarResponse)
async def grammar_explanation(
    payload: GrammarRequest,
    x_device_uuid: str = Header(..., alias="X-Device-UUID"),
    x_app_language: str = Header(..., alias="X-App-Language"),
    db: AsyncSession = Depends(get_db)
):
    user = await get_or_create_user(db, x_device_uuid, x_app_language)
    
    # Recurso exclusivo Pro
    if not user.is_premium:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="O Tutor Gramatical é um recurso Pro. Adquira a assinatura Premium para utilizá-lo!"
        )
        
    try:
        explanation = await AiService.get_grammar_explanation(
            app_language=x_app_language,
            phrase=payload.phrase,
            context_topic=payload.context_topic
        )
        return GrammarResponse(explanation=explanation)
    except Exception as e:
        logger.error(f"Erro no tutor gramatical: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao processar explicação: {str(e)}"
        )

@router.post("/tts")
async def text_to_speech(
    payload: TtsRequest,
    x_device_uuid: str = Header(..., alias="X-Device-UUID"),
    x_app_language: str = Header(..., alias="X-App-Language"),
    db: AsyncSession = Depends(get_db)
):
    user = await get_or_create_user(db, x_device_uuid, x_app_language)
    
    # Recurso exclusivo Pro
    if not user.is_premium:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="As Vozes Ultra-Realistas da OpenAI são um recurso Pro. Adquira a assinatura Premium para utilizá-las!"
        )
        
    try:
        file_path = await AiService.get_realistic_voice_audio(
            text=payload.text,
            voice=payload.voice,
            speed=payload.speed
        )
        return FileResponse(file_path, media_type="audio/mpeg", filename=os.path.basename(file_path))
    except Exception as e:
        logger.error(f"Erro no TTS proxy: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Erro ao sintetizar áudio realista: {str(e)}"
        )
