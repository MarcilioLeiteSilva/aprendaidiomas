import json
import logging
from datetime import datetime, timedelta, timezone
from typing import Tuple, Optional
from google.oauth2 import service_account
from googleapiclient.discovery import build
from app.config import settings

logger = logging.getLogger(__name__)

class GooglePlayService:
    @staticmethod
    def verify_subscription(
        package_name: str,
        product_id: str,
        purchase_token: str
    ) -> Tuple[bool, str, Optional[datetime]]:
        """
        Verifica o recibo da assinatura com a Google Play Developer API.
        Retorna uma tupla (sucesso, mensagem, data_de_expiracao).
        """
        if settings.MOCK_GOOGLE_PLAY:
            logger.info("MOCK_GOOGLE_PLAY ativado. Simulando assinatura com sucesso por 30 dias.")
            # Simula assinatura ativa até daqui a 30 dias
            expires_at = datetime.now(timezone.utc) + timedelta(days=30)
            return True, "Mock verification successful (Premium ativo)", expires_at

        if not settings.GOOGLE_SERVICE_ACCOUNT_JSON:
            logger.error("GOOGLE_SERVICE_ACCOUNT_JSON não configurado, e MOCK_GOOGLE_PLAY é falso.")
            return False, "Google Play credentials missing on server", None

        try:
            # Carrega a credencial da Conta de Serviço (JSON format ou arquivo de texto)
            if settings.GOOGLE_SERVICE_ACCOUNT_JSON.strip().startswith("{"):
                creds_dict = json.loads(settings.GOOGLE_SERVICE_ACCOUNT_JSON)
            else:
                with open(settings.GOOGLE_SERVICE_ACCOUNT_JSON, "r") as f:
                    creds_dict = json.load(f)

            scopes = ["https://www.googleapis.com/auth/androidpublisher"]
            credentials = service_account.Credentials.from_service_account_info(
                creds_dict, scopes=scopes
            )

            # Inicializa a API do Android Publisher
            service = build("androidpublisher", "v3", credentials=credentials)

            # Consulta o status da assinatura na Google Play
            request = service.purchases().subscriptions().get(
                packageName=package_name,
                subscriptionId=product_id,
                token=purchase_token
            )
            response = request.execute()

            # Extrai o tempo de expiração em milissegundos
            expiry_time_ms = response.get("expiryTimeMillis")
            if not expiry_time_ms:
                return False, "Google Play API não retornou a data de expiração da assinatura", None

            # Converte para datetime com timezone utc
            expires_at = datetime.fromtimestamp(int(expiry_time_ms) / 1000.0, tz=timezone.utc)
            now = datetime.now(timezone.utc)

            # Se expira no futuro, está ativa
            if expires_at > now:
                return True, "Subscription is active", expires_at
            else:
                return False, "Subscription has expired", expires_at

        except Exception as e:
            logger.error(f"Erro ao validar compra no Google Play Billing: {str(e)}")
            return False, f"Google Play API Error: {str(e)}", None
