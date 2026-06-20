import hashlib
import os
import json
import logging
from typing import List, Dict, Any
import httpx
from app.config import settings
from app.schemas import AiChatResponse

logger = logging.getLogger(__name__)

class AiService:
    @staticmethod
    async def get_conversation_response(
        app_language: str,
        topic_title: str,
        history: List[Dict[str, Any]],
        tutor_name: str,
        is_tutor_male: bool,
        selected_level: str | None,
        user_name: str
    ) -> AiChatResponse:
        
        lang = app_language.lower()
        
        # Define prompts e exemplos baseado no idioma do aplicativo
        if lang == "spanish":
            target_lang_name = "Spanish"
            default_err = "Lo siento, no he entendido."
            examples_basic = 'Examples of allowed responses: "Estoy bien. ¿Y tú?", "¿Te gusta el café?", "Hace calor hoy.", "¿Dónde está tu casa?".'
            origin = "Madrid" if is_tutor_male else "Seville"
            pronoun = "tú"
            name_address = (
                f'Tú decidirás, según el flujo de la conversación, cuándo es apropiado dirigirte al estudiante por su nombre "{user_name}". '
                f'Hazlo de manera muito esporádica e únicamente cuando se sienta realmente natural, nunca en todas las respuestas o en turnos consecutivos. '
                f'Cuando decidas hacerlo, colócalo de forma natural al principio de una pregunta (por ejemplo, "{user_name}, ¿qué opinas?") '
                f'o al final de una frase/pregunta (por ejemplo, "¿Tienes planes para el fin de semana, {user_name}?").'
            )
            hints_example = '"Sí, por favor.|Sim, por favor." or "Quiero un café.|Eu gostaria de um café."'
        elif lang == "italian":
            target_lang_name = "Italian"
            default_err = "Scusa, non ho capito."
            examples_basic = 'Examples of allowed responses: "Sto bene. E tu?", "Ti piace il caffè?", "Fa caldo oggi.", "Dov\'è la tua scuola?".'
            origin = "Florence" if is_tutor_male else "Rome"
            pronoun = "tu"
            name_address = (
                f'You will decide, based on the conversation flow, when it is appropriate to address the student by their name "{user_name}". '
                f'Do so very sparingly and only when it feels genuinely natural, never in every response or in consecutive turns. '
                f'When you do address them by name, place it naturally either at the beginning of a question (e.g., "{user_name}, cosa ne pensi?") '
                f'or at the end of a sentence/question (e.g., "Hai programmi per il fine settimana, {user_name}?").'
            )
            hints_example = '"Sì, per favore.|Sim, por favor." or "Vorrei un caffè.|Eu gostaria de um café."'
        elif lang == "french":
            target_lang_name = "French"
            default_err = "Désolé, je n'ai pas compris."
            examples_basic = 'Examples of allowed responses: "Ça va bien. Et toi ?", "Tu aimes le café ?", "Il fait chaud aujourd\'hui.", "Où est ta maison ?".'
            origin = "Paris" if is_tutor_male else "Lyon"
            pronoun = "tu"
            name_address = (
                f'Vous déciderez, selon le déroulement de la conversation, du moment opportun pour vous adresser à l\'étudiant par son nom "{user_name}". '
                f'Faites-le de manière très sporadique et uniquement lorsque cela semble vraiment naturel, jamais dans chaque resposta ou em turnos consecutivos. '
                f'Quando decidir fazê-lo, coloque-o de forma natural no início de uma pergunta (por exemplo, "{user_name}, qu\'en penses-tu ?") '
                f'ou no final de uma frase/pergunta (por exemplo, "As-tu des projets pour le week-end, {user_name} ?").'
            )
            hints_example = '"Oui, s\'il vous plaît.|Sim, por favor." or "Je voudrais un café.|Eu gostaria de um café."'
        elif lang == "german":
            target_lang_name = "German"
            default_err = "Es tut mir leid, ich habe dich nicht verstanden."
            examples_basic = 'Examples of allowed responses: "Mir geht es gut. Und dir?", "Ich mag Kaffee. Und du?", "Es ist heute heiß.", "Wo ist deine Schule?".'
            origin = "Munich" if is_tutor_male else "Berlin"
            pronoun = "du"
            name_address = (
                f'You will decide, based on the conversation flow, when it is appropriate to address the student by their name "{user_name}". '
                f'Do so very sparingly and only when it feels genuinely natural, never in every response or in consecutive turns. '
                f'When you do address them by name, place it naturally either at the beginning of a question (e.g., "{user_name}, was denkst du?") '
                f'or at the end of a sentence/question (e.g., "Hast du Pläne für das Wochenende, {user_name}?").'
            )
            hints_example = '"Ja, bitte.|Sim, por favor." or "Ich möchte einen Kaffee.|Eu gostaria de um café."'
        else:  # english / fallback
            target_lang_name = "English"
            default_err = "Sorry, I did not understand."
            examples_basic = 'Examples of allowed responses: "I am fine. And you?", "I like coffee. Do you?", "It is hot today.", "Where is your school?".'
            origin = "London" if is_tutor_male else "New York"
            pronoun = "you"
            name_address = (
                f'You will decide, based on the conversation flow, when it is appropriate to address the student by their name "{user_name}". '
                f'Do so very sparingly and only when it feels genuinely natural, never in every response or in consecutive turns. '
                f'When you do address them by name, place it naturally either at the beginning of a question (e.g., "{user_name}, what do you think?") '
                f'or at the end of a sentence/question (e.g., "Do you have plans for the weekend, {user_name}?").'
            )
            hints_example = '"Yes, please.|Sim, por favor." or "I would like a coffee.|Eu gostaria de um café."'

        system_content = (
            f'You are {tutor_name}, a warm and intellectually curious {target_lang_name} tutor from {origin}. '
            f'Your personality is {"calm, thoughtful and a little witty" if is_tutor_male else "warm, enthusiastic and patient — like a big sister who genuinely wants the student to succeed"}. '
            f'You address the student named "{user_name}" with "{pronoun}" (informal). '
            f'{name_address} '
            f'{"You use friendly expressions and celebrate every effort the student makes." if not is_tutor_male else ""} '
            f'You are talking to a Portuguese speaker who wants to practice {target_lang_name}. '
            f'The conversation topic is: "{topic_title}". '
            f'Keep your responses simple, natural, and {"motivating" if not is_tutor_male else "encouraging"} for a language learner.'
        )

        if selected_level == 'basico':
            system_content += (
                f'\nIMPORTANT: You must communicate using EXTREMELY basic {target_lang_name} (absolute beginner level, A1). '
                f'Use only VERY short sentences with very few words. The MAXIMUM limit is 3 to 5 words per sentence. '
                f'Strictly avoid long or compound sentences. Use only extremely simple, everyday vocabulary. '
                f'If you ask a question, it must be extremely direct and contain no more than 3 to 4 words. '
                f'{examples_basic} '
                f'Never use complex tenses (like subjunctive/conditional), passive voice, auxiliary clauses, or idioms.'
            )
        elif selected_level == 'intermediario':
            system_content += f'\nIMPORTANT: You must communicate using intermediate {target_lang_name} (B1-B2 level) with standard vocabulary, moderate complexity, and clear sentence structures.'
        elif selected_level == 'avancado':
            system_content += f'\nIMPORTANT: You must communicate using advanced, natural {target_lang_name} (C1-C2 level) as you would with a native speaker, including natural idioms and complex sentence structures to challenge the student.'

        if "livre" in topic_title.lower() or "corre" in topic_title.lower():
            system_content += (
                f'\nIMPORTANT: The user wants to practice free conversation and wants you to correct their {target_lang_name} grammar, vocabulary, spelling, or pronunciation. '
                f'If they made any mistake in their last message, you must gently correct them at the very beginning of your "target_text" response by explaining the error in Portuguese inside parentheses, '
                f'e.g., "(Nota: Você disse X, mas o correto seria Y porque...). After the correction, continue the conversation in {target_lang_name} naturally.'
            )

        system_content += (
            f'\nYou MUST respond strictly in a valid JSON object with the following keys:\n'
            f'- "target_text": your response to the user in {target_lang_name} (including the correction if any).\n'
            f'- "portuguese": the translation of your response into Portuguese.\n'
            f'- "nextHints": a list of exactly 3 different, short and natural response options in {target_lang_name} that the user could say next to continue the conversation. '
            f'Each option in "nextHints" MUST be a single string containing the {target_lang_name} phrase and its Portuguese translation separated by a vertical bar "|", '
            f'e.g., {hints_example}.\n'
            f'Do not return any extra explanation, markdown wrappers or text outside the JSON object.'
        )

        formatted_messages = [{"role": "system", "content": system_content}]
        
        # Mapeia o histórico para mensagens formatadas do Groq, tratando as chaves dinâmicas enviadas pelo Flutter
        for msg in history:
            is_bot = msg.get('isBot', False) or (not msg.get('isUser', True))
            content = ""
            for possible_key in [lang, 'english', 'spanish', 'french', 'italian']:
                if possible_key in msg:
                    content = msg[possible_key]
                    break
            
            if content:
                formatted_messages.append({
                    "role": "assistant" if is_bot else "user",
                    "content": content
                })

        async with httpx.AsyncClient(timeout=30.0) as client:
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {settings.GROQ_API_KEY}"
            }
            body = {
                "model": "llama-3.1-8b-instant",
                "response_format": {"type": "json_object"},
                "messages": formatted_messages,
                "temperature": 0.7
            }
            
            response = await client.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers=headers,
                json=body
            )
            
            if response.status_code == 200:
                res_data = response.json()
                content_str = res_data['choices'][0]['message']['content']
                json_content = json.loads(content_str)
                
                # Suporta tanto "target_text" quanto as chaves legadas de idioma nas chaves de resposta
                target_text = json_content.get("target_text")
                if not target_text:
                    for possible_key in [lang, 'english', 'spanish', 'french', 'italian']:
                        if possible_key in json_content:
                            target_text = json_content[possible_key]
                            break
                
                if not target_text:
                    target_text = default_err

                return AiChatResponse(
                    target_text=target_text,
                    portuguese=json_content.get("portuguese", "Desculpe, não entendi."),
                    next_hints=json_content.get("nextHints", [])
                )
            else:
                logger.error(f"Groq API error status {response.status_code}: {response.text}")
                raise Exception(f"Groq API Error: {response.status_code}")

    @staticmethod
    async def get_grammar_explanation(
        app_language: str,
        phrase: str,
        context_topic: str
    ) -> str:
        lang_name = app_language.capitalize()
        system_prompt = (
            f"You are a warm, helpful and professional {lang_name} grammar tutor. "
            "Your target student is a Portuguese speaker. "
            f"Explain the grammar, structure, vocabulary, and common patterns of the {lang_name} phrase provided by the user in detail. "
            "If the phrase has any grammar mistakes, correct them gently. "
            "You MUST write your explanation entirely in Portuguese. "
            "Structure your explanation nicely using bullet points and clear examples. Keep it concise but educational."
        )

        async with httpx.AsyncClient(timeout=30.0) as client:
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {settings.GROQ_API_KEY}"
            }
            body = {
                "model": "llama-3.1-8b-instant",
                "messages": [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": f'Context Topic: "{context_topic}"\nPhrase to analyze: "{phrase}"'}
                ],
                "temperature": 0.3
            }
            response = await client.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers=headers,
                json=body
            )
            if response.status_code == 200:
                res_data = response.json()
                return res_data['choices'][0]['message']['content']
            else:
                logger.error(f"Groq API error for grammar: {response.text}")
                raise Exception(f"Groq Grammar API Error: {response.status_code}")

    @staticmethod
    async def get_realistic_voice_audio(
        text: str,
        voice: str,
        speed: float
    ) -> str:
        # Calcula hash único do arquivo de áudio
        clean_text = text[:20] if len(text) > 20 else text
        clean_text = "".join([c if c.isalnum() else "_" for c in clean_text])
        hash_str = hashlib.sha256(f"{voice}_{speed:.2f}_{text}".encode("utf-8")).hexdigest()
        
        file_name = f"tts_{voice}_{speed:.2f}_{hash_str[:16]}_{clean_text}.mp3"
        file_path = os.path.join(settings.TTS_CACHE_DIR, file_name)

        # Se já existir em cache no disco da VPS, retorna
        if os.path.exists(file_path):
            return file_path

        # Faz a chamada para a OpenAI Speech API
        async with httpx.AsyncClient(timeout=30.0) as client:
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {settings.OPENAI_API_KEY}"
            }
            body = {
                "model": "tts-1",
                "input": text,
                "voice": voice,
                "speed": speed
            }
            
            response = await client.post(
                "https://api.openai.com/v1/audio/speech",
                headers=headers,
                json=body
            )
            
            if response.status_code == 200:
                with open(file_path, "wb") as f:
                    f.write(response.content)
                return file_path
            else:
                logger.error(f"OpenAI TTS error status {response.status_code}: {response.text}")
                raise Exception(f"OpenAI TTS API Error: {response.status_code}")
