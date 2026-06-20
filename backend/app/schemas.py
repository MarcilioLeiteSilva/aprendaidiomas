from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Dict, Any, Optional

class UserProfileResponse(BaseModel):
    device_id: str
    app_language: str
    is_premium: bool
    premium_until: Optional[datetime] = None
    free_messages_used_today: int
    limit_reached: bool

    class Config:
        from_attributes = True

class AiChatRequest(BaseModel):
    topic_id: str
    topic_title: str
    history: List[Dict[str, Any]]
    tutor_name: str = "Giulia"
    is_tutor_male: bool = False
    selected_level: Optional[str] = None

class AiChatResponse(BaseModel):
    target_text: str
    portuguese: str
    next_hints: List[str]

class GrammarRequest(BaseModel):
    phrase: str
    context_topic: str

class GrammarResponse(BaseModel):
    explanation: str

class TtsRequest(BaseModel):
    text: str
    voice: str
    speed: float = 1.0

class PurchaseVerifyRequest(BaseModel):
    purchase_token: str
    product_id: str
    package_name: str

class PurchaseVerifyResponse(BaseModel):
    success: bool
    message: str
    is_premium: bool
    premium_until: Optional[datetime] = None
