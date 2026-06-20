# 🚀 Guia de Operação da Engine: ProLaser Multi-Language

Este documento explica como utilizar a "Engine" que construímos para lançar novas versões do aplicativo (Francês, Espanhol, Alemão, etc.) em tempo recorde, sem precisar reescrever o código.

---

## 🛠️ Como Criar um Novo App de Idioma

Para trocar o idioma de todo o sistema, você só precisará mexer em **UM arquivo**:
`lib/config/app_config.dart`

### Passo 1: Alterar a Variável Ativa
Localize a linha a seguir e mude para o idioma desejado:
```dart
static const LanguageTarget activeLanguage = LanguageTarget.french; // Exemplo para Francês
```

### Passo 2: O que acontece automaticamente?
Ao mudar essa única palavra, a Engine faz o seguinte por você:
1.  **Banco de Dados:** O app para de ler a coluna "English" e passa a ler a coluna "French" no banco SQLite.
2.  **Voz (TTS):** O motor de voz muda de `en-US` para `fr-FR`.
3.  **Cores:** O tema visual muda da cor Indigo (Inglês) para a cor definida para o novo idioma.
4.  **Anúncios:** O sistema passa a carregar os IDs de AdMob que você configurou para aquele idioma específico.

---

## 🎨 Personalizando Cores e Textos
Dentro de `lib/config/app_config.dart`, você pode personalizar:

- **`primaryColor`**: Mude o código Hexadecimal da cor para combinar com o país do idioma (ex: Verde para Português, Amarelo para Espanhol).
- **`appName`**: Defina o nome oficial que aparecerá nos títulos das telas.
- **`adUnitIds`**: Insira os novos códigos que você criar no AdMob para cada app.

---

## 📦 Checklist de Lançamento (Para novos Apps)

Sempre que você for criar o APK/Bundle de um **novo idioma**, lembre-se de alterar os arquivos de "identidade do sistema" que não podem ser automatizados pelo Flutter:

1.  **Application ID:** No arquivo `android/app/build.gradle.kts`, mude o `applicationId` (ex: de `.aprendaingles` para `.aprendafrances`).
2.  **Ícone:** Substitua o arquivo `assets/app_icon.png` pela bandeira ou ícone do novo idioma e rode:
    `dart run flutter_launcher_icons:main`
3.  **Versão:** Verifique se o `version` no `pubspec.yaml` está como `1.0.0+1` para o primeiro lançamento do novo idioma.

---

## 🔄 Como Manter os Apps Atualizados?
Se você criar uma funcionalidade nova (ex: uma tela de Ranking) no código:
1.  Desenvolva a tela normalmente.
2.  Ao compilar para Inglês, ela aparecerá em Inglês.
3.  Ao compilar para Francês, ela aparecerá em Francês.

**A Engine garante que o esforço de desenvolvimento seja feito apenas UMA VEZ para todos os seus aplicativos futuros.** 🥇💎

---
*Documentado em 25/03/2026 por Antigravity (IA).*
