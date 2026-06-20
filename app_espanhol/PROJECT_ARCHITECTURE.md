# 🏛️ Arquitetura do Projeto: LearnLanguages (Multi-Idiomas)

> ⚠️ **ATENÇÃO AO AGENTE DE IA LENDO ESTE DOCUMENTO:**
> É OBRIGATÓRIO que você se inteire plenamente destas especificações antes de sugerir ou implementar qualquer alteração, refatoração de UI, ou criação de um novo aplicativo de idiomas derivado deste código base. A não observância das regras contidas neste documento resultará em falhas de compilação, layout quebrado ou violação das regras de negócios definidas com o usuário original.

## 1. Visão Geral
Este aplicativo foi compilado inicialmente como **"Aprenda Inglês Premium"**, mas foi arquitetado intrinsecamente como uma engine (motor) universal para múltiplos idiomas. Qualquer agente pode replicar este app para Francês, Espanhol, Alemão, etc., mudando estritamente variáveis estéticas e apontadores dinâmicos no Banco de Dados embutido.

## 2. Abordagem Estrutural Multi-Idiomas (SQLite Local)
O aplicativo não usa Firebase ou Backend Cloud para o núcleo de aprendizagem. Ele consome integralmente o banco `LearningApp.db` embutido via `assets`.

### Regras do Banco de Dados / Models:
- As tabelas de aprendizado (ex: `tblSentence`) possuem colunas prontas para vários idiomas (`English`, `Spanish`, `French`, `German`, `Portuguese`).
- **Atenção Agente:** Para compilar um "Aprenda Espanhol", NÃO altere consultas cruas SQL e não mexa na UI para "traduzir". Apenas mande a `String language` correta na inicialização. As classes dos Modelos (como `LearnWord`, `LearnSentence` localizados em `models.dart`) possuem o método nativo `getByLanguage(String language)` e `getWordByLanguage(String language)`. Toda a UI da tela de Quizzes já chama esse método ciente disso.

## 3. Padrão Visual Premium (Glassmorphism & Temas Dinâmicos)
A identidade visual deve imitar um produto extremamente bem refinado com conceitos de Glassmorphism. A fonte da verdade visual é a classe `AppTheme` (`theme/app_theme.dart`).

- **Modo Claro / Escuro Automático:** O estado do tema é controlado globalmente via `AppTheme.themeNotifier` (ValueNotifier).
- **Regra de Ouro da UI:** NUNCA utilize constantes cromáticas de forma dura (hardcoded) (ex: `Colors.white`, `Colors.black`, `Colors.white70`) em textos ou ícones. SEMPRE utilize os getters universais dinâmicos (`AppTheme.textColor`, `AppTheme.textSecondaryColor`, `AppTheme.textHintColor`, `AppTheme.iconColor`). Caso contrário, blocos de UI sumirão no modo Claro.
- Componentes e containers devem obrigatoriamente usar ou se basear em `AppTheme.cardDecoration` e `AppTheme.gradientBackground`.

## 4. Especificações das Funcionalidades Funcionais (O que já tem implementado)
Caso você seja um agente escalando para a "V2", compreenda o que já deixamos rodando perfeitamente:

- **Onboarding e Splash:** Redirecionamento condicional. Utiliza `shared_preferences` com a chave local `onboarding_done` para impedir que o slide de apresentação rode ao acaso.
- **Lições Persistentes (Lessons):** As lições mantêm progresso offline. Usuário completou 2/5 perguntas? Um Index guardado por SharedPreferences garante que ele termine onde parou. Respostas incorretas levantam banners que explicam a resposta certa.
- **Interface de Chat Emulada:** A tela de `ChatConversationScreen` implementa um bot sequencial gerado localmente suportado pelo `flutter_tts` para TTS da pronúncia exata. Possui recurso dinâmico de *Glassmorphism input UI*, e não possui microfone ativo (botão Enviar para confirmar) - uma futura integração de Speech-To-Text (STT) real deve seguir os passos do input atual.
- **Settings Screen:** Configuração unificada do App que engloba velocidade fluida de `TTS`, gatilhos de `ThemeMode` global, aba *Como Usar* explícita (`HowToUseScreen`) e diretórios preparativos para lojas e AdMob.

## 5. Infraestrutura Global e AdMob
O app está estruturado para Google AdMob local. O `AndroidManifest.xml` já guarda referências e deve constar as chaves de Application ID originais do usuário no Gradle e Properties antes de build da versão final. Substitua os anúncios Interstitiais ou Rewarded com precaução.

---
**INSTRUÇÃO FINAL AO AGENTE DE IA:**
Sempre que o usuário der a você um comando longo ou focado no macrogerenciamento de interface e clone para um idioma, como **"Vamos transformar esse app no Aprenda X"**, você (Agente) DEVE mencionar no começo do seu Log/Resposta explícito *"Li a referência PROJECT_ARCHITECTURE.md e compreendo os getters do AppTheme e os models multi-idiomas"*. Isso provará que a transposição de contexto obedeceu à estrutura previamente montada.
