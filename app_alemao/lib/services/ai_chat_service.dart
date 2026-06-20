import 'package:flutter/material.dart';

class AiTopic {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  // Templates use {TUTOR} as placeholder for the tutor's name
  final Map<String, String> initialMessageTemplate;
  final List<String> initialHints;

  const AiTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.initialMessageTemplate,
    required this.initialHints,
  });

  /// Returns the initial message with {TUTOR} replaced by the actual tutor name.
  Map<String, String> getInitialMessage(String tutorName) {
    return {
      'en': initialMessageTemplate['en']!.replaceAll('{TUTOR}', tutorName),
      'pt': initialMessageTemplate['pt']!.replaceAll('{TUTOR}', tutorName),
    };
  }

  // Backward-compat getter
  Map<String, String> get initialMessage => getInitialMessage('Emma');
}

class AiResponse {
  final String english;
  final String portuguese;
  final List<String> nextHints;

  const AiResponse({
    required this.english,
    required this.portuguese,
    required this.nextHints,
  });
}

class AiChatService {
  static final List<AiTopic> topics = [
    const AiTopic(
      id: 'cafe',
      title: 'Pedindo no Café Alemão ☕',
      description: 'Pratique pedir um café, lanches e interagir com o garçom em Berlim ou Munique.',
      icon: Icons.coffee_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Mein Name ist {TUTOR}. Willkommen in unserem Café. Was darf ich Ihnen heute bringen?',
        'pt': 'Olá! Eu me chamo {TUTOR}. Bem-vindo ao nosso café. O que posso lhe servir hoje?'
      },
      initialHints: [
        'Eine Tasse Kaffee, bitte.|Um café, por favor.',
        'Was empfehlen Sie?|O que você recomenda?',
        'Ich hätte gerne ein Croissant.|Eu gostaria de um croissant.'
      ],
    ),
    const AiTopic(
      id: 'turismo',
      title: 'Explorando a Alemanha 🇩🇪',
      description: 'Pergunte direções, recomendações do Portão de Brandemburgo, Alexanderplatz ou pontos turísticos.',
      icon: Icons.explore_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Mein Name ist {TUTOR}, Ihr lokaler Reiseführer. Was ist Ihr nächstes Ziel in der Stadt?',
        'pt': 'Olá! Eu me chamo {TUTOR}, seu guia local. Qual é o seu próximo destino na cidade?'
      },
      initialHints: [
        'Wo ist die nächste U-Bahn-Station, bitte?|Onde fica a estação de metrô mais próxima, por favor?',
        'Ich möchte das Brandenburger Tor besuchen.|Quero visitar o Portão de Brandemburgo.',
        'Was sind die besten Restaurants in der Nähe?|Quais são os melhores lugares para comer por perto?'
      ],
    ),
    const AiTopic(
      id: 'aeroporto',
      title: 'Imigração e Aeroporto ✈️',
      description: 'Pratique responder às perguntas do oficial de imigração, fazer check-in ou pedir ajuda com as malas.',
      icon: Icons.local_airport_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Willkommen am Einreiseschalter. Was ist der Zweck Ihrer Reise?',
        'pt': 'Olá! Bem-vindo ao balcão de imigração. Qual é o propósito da sua visita?'
      },
      initialHints: [
        'Ich bin als Tourist hier.|Estou aqui a turismo.',
        'Ich bleibe für zwei Wochen.|Vou ficar por duas semanas.',
        'Ich besuche ein paar Freunde.|Estou visitando alguns amigos.'
      ],
    ),
    const AiTopic(
      id: 'hotel',
      title: 'Check-in no Hotel 🏨',
      description: 'Pratique fazer check-in na recepção, confirmar sua reserva e pedir a senha do Wi-Fi.',
      icon: Icons.hotel_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Willkommen in unserem Hotel. Haben Sie eine Reservierung auf Ihren Namen?',
        'pt': 'Olá! Bem-vindo ao nosso hotel. Você tem uma reserva em seu nome?'
      },
      initialHints: [
        'Ja, meine Reservierung läuft auf den Namen Alex.|Sim, minha reserva está sob o nome Alex.',
        'Um wie viel Uhr gibt es Frühstück?|Que horas o café da manhã é servido?',
        'Gibt es kostenloses WLAN im Zimmer?|Tem Wi-Fi gratuito no quarto?'
      ],
    ),
    const AiTopic(
      id: 'compras',
      title: 'Compras na Loja 🛍️',
      description: 'Pratique pedir tamanhos diferentes de roupas, perguntar os preços e efetuar o pagamento.',
      icon: Icons.shopping_bag_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Willkommen. Sagen Sie mir Bescheid, wenn Sie Hilfe bei der Suche nach einer bestimmten Größe oder Farbe benötigen. Suchen Sie etwas Bestimmtes?',
        'pt': 'Olá! Bem-vindo. Diga-me se precisar de ajuda para encontrar qualquer tamanho ou cor. Está procurando algo específico?'
      },
      initialHints: [
        'Ich schaue mich nur um, danke.|Só estou dando uma olhadinha, obrigado.',
        'Haben Sie dieses Hemd in Größe M?|Você tem essa camisa no tamanho M?',
        'Wie viel kostet diese Jacke?|Quanto custa esta jaqueta?'
      ],
    ),
    const AiTopic(
      id: 'casual',
      title: 'Conversa Casual e Amizade 👋',
      description: 'Fale sobre seus hobbies, de onde você é e o que está achando da cidade.',
      icon: Icons.chat_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Schön, Sie kennenzulernen. Mein Name ist {TUTOR}. Wie geht es Ihnen heute?',
        'pt': 'Oi! Prazer em te conhecer. Eu me chamo {TUTOR}. Como você vai hoje?'
      },
      initialHints: [
        'Mir geht es super, danke! Und Ihnen?|Estou ótimo, obrigado! E você?',
        'Ich bin ein bisschen müde, aber es geht mir gut.|Estou um pouco cansado, mas bem.',
        'Ich heiße Alex und komme aus Brasilien.|Meu nome é Alex e sou do Brasil.'
      ],
    ),
    const AiTopic(
      id: 'livre',
      title: 'Conversa Livre & Correções 💬',
      description: 'Converse livremente sobre qualquer assunto. O tutor corrigirá seus erros.',
      icon: Icons.psychology_rounded,
      initialMessageTemplate: {
        'en': 'Hallo! Mein Name ist {TUTOR}. Lass uns heute über das reden, worüber du willst! Du kannst gerne Sätze schreiben, ich bin hier, um deine Fehler zu korrigieren.',
        'pt': 'Olá! Eu me chamo {TUTOR}. Vamos conversar sobre o que você quiser hoje! Sinta-se à vontade para formar frases, estou aqui para corrigir seus erros.'
      },
      initialHints: [
        'Heute geht es mir sehr gut.|Hoje eu estou muito bem.',
        'Ich möchte über meine Hobbys sprechen.|Eu gostaria de falar sobre meus hobbies.',
        'Kannst du mir beim Üben helfen?|Você pode me ajudar a praticar?'
      ],
    ),
  ];

  // A simple rule-based local simulation that feels like real AI conversation
  static AiResponse generateResponse(String topicId, String userMessage) {
    final cleanMsg = userMessage.toLowerCase().trim();

    if (topicId == 'cafe') {
      if (cleanMsg.contains('recommend') || cleanMsg.contains('recomenda') || cleanMsg.contains('empfehlen') || cleanMsg.contains('empfiehlst')) {
        return const AiResponse(
          english: 'Ich empfehle unsere Spezialität: heiße Schokolade mit frisch gebackenen Muffins. Es ist köstlich! Möchten Sie es probieren?',
          portuguese: 'Recomendo a nossa especialidade: chocolate quente com muffins assados na hora. É delicioso! Você gostaria de experimentar?',
          nextHints: [
            'Ja, bitte, ich möchte einen.|Sim, por favor, eu quero um.',
            'Wie viel kostet das?|Quanto custa?',
            'Nein danke, ich bevorzuge einen Tee.|Não obrigado, prefiro um chá.'
          ],
        );
      }
      if (cleanMsg.contains('muffin') || cleanMsg.contains('kaffee') || cleanMsg.contains('coffee') || cleanMsg.contains('essen') || cleanMsg.contains('want') || cleanMsg.contains('möchte')) {
        return const AiResponse(
          english: 'Hervorragende Wahl! Ein warmer Muffin und frischer Kaffee. Möchten Sie noch etwas trinken? Vielleicht ein Glas Saft?',
          portuguese: 'Excelente escolha! Um muffin quentinho e café fresco. Você gostaria de algo mais para beber? Um copo de suco, talvez?',
          nextHints: [
            'Ein Glas Orangensaft, bitte.|Um copo de suco de laranja, por favor.',
            'Eine Flasche Wasser, bitte.|Uma garrafa de água, por favor.',
            'Nein, das ist alles, danke.|Não, é só isso, obrigado.'
          ],
        );
      }
      if (cleanMsg.contains('how much') || cleanMsg.contains('bill') || cleanMsg.contains('pay') || cleanMsg.contains('cost') || cleanMsg.contains('rechnung') || cleanMsg.contains('zahlen') || cleanMsg.contains('kostet')) {
        return const AiResponse(
          english: 'Das macht insgesamt sechs Euro und fünfzig Cent. Bevorzugen Sie Kartenzahlung oder Barzahlung?',
          portuguese: 'Fica seis euros e cinquenta no total. Você prefere pagar com cartão ou em dinheiro?',
          nextHints: [
            'Ich bezahle mit Karte.|Vou pagar com cartão.',
            'Hier sind zehn Euro. Stimmt so.|Aqui estão dez euros. Fique com o troco.',
            'Kann ich mit Kreditkarte bezahlen?|Posso pagar com cartão de crédito?'
          ],
        );
      }
      if (cleanMsg.contains('danke') || cleanMsg.contains('thanks') || cleanMsg.contains('thank you') || cleanMsg.contains('tschüss') || cleanMsg.contains('bye')) {
        return const AiResponse(
          english: 'Gern geschehen! Vielen Dank für Ihren Besuch und einen schönen Tag noch!',
          portuguese: 'De nada! Muito obrigado pela visita e tenha um ótimo dia!',
          nextHints: [
            'Vielen Dank, tschüss!|Muito obrigado, tchau!',
            'Bis später!|Até logo!',
            'Gleichfalls, einen schönen Tag.|Igualmente, tenha um bom dia.'
          ],
        );
      }
      // Default cafe response
      return const AiResponse(
        english: 'Alles klar! Ich bringe Ihnen das in einen Moment. Möchten Sie noch etwas zu Ihrer Bestellung hinzufügen?',
        portuguese: 'Anotado! Trago isso para você em um instante. Deseja algo mais com o seu pedido?',
        nextHints: [
          'Nein, das ist alles, danke.|Não, é só isso, obrigado!',
          'Bringen Sie mir bitte die Rechnung.|Traga-me a conta, por favor.',
          'Kann ich etwas Zucker haben?|Pode me trazer açúcar?'
        ],
      );
    } 
    
    else if (topicId == 'turismo') {
      if (cleanMsg.contains('u-bahn') || cleanMsg.contains('subway') || cleanMsg.contains('metro') || cleanMsg.contains('station') || cleanMsg.contains('bahnhof')) {
        return const AiResponse(
          english: 'Die nächste U-Bahn-Station ist nur zwei Häuserblocks entfernt. Sie können die Rote Linie direkt in die Innenstadt nehmen. Haben Sie eine Fahrkarte?',
          portuguese: 'A estação de metrô mais próxima fica a apenas dois quarteirões de distância. Você pode pegar a Linha Vermelha direto para o centro. Você tem um cartão de transporte?',
          nextHints: [
            'Ja, ich habe eine.|Sim, eu tenho um.',
            'Nein, wo kann ich eine kaufen?|Não, onde posso comprar um?',
            'Wie viel kostet eine Einzelfahrkarte?|Quanto custa um bilhete único?'
          ],
        );
      }
      if (cleanMsg.contains('park') || cleanMsg.contains('brandenburger') || cleanMsg.contains('tor') || cleanMsg.contains('museum')) {
        return const AiResponse(
          english: 'Das Brandenburger Tor und der Tiergarten sind wunderschön! Sie sollten ein Fahrrad mieten, um alles zu erkunden. Waren Sie schon dort?',
          portuguese: 'O Portão de Brandemburgo e o Tiergarten são lindos! Você deveria alugar uma bicicleta para explorar tudo. Você já esteve lá?',
          nextHints: [
            'Nein, noch nicht.|Não, ainda não.',
            'Ja, ich war gestern dort.|Sim, eu fui lá ontem.',
            'Welche anderen Attraktionen empfehlen Sie?|Quais outras atrações você recomenda?'
          ],
        );
      }
      if (cleanMsg.contains('essen') || cleanMsg.contains('eat') || cleanMsg.contains('restaurant') || cleanMsg.contains('food') || cleanMsg.contains('hunger')) {
        return const AiResponse(
          english: 'Für lokales Essen sollten Sie eine Currywurst oder eine traditionelle Brezel in der Nähe probieren. Mögen Sie Currywurst?',
          portuguese: 'Para comida local, você deveria experimentar uma Currywurst ou uma pretzel tradicional por aqui. Você gosta de Currywurst?',
          nextHints: [
            'Ja, ich liebe Currywurst!|Sim, eu adoro Currywurst!',
            'Welche anderen lokalen Gerichte sollte ich probieren?|Quais outros pratos locais devo provar?',
            'Nein, ich bevorzuge gesunde Küche.|Não, eu prefiro comida saudável.'
          ],
        );
      }
      // Default turismo response
      return const AiResponse(
        english: 'Diese Stadt hat so viel zu bieten! Von Museen bis zu schönen Parks, Sie werden es lieben. Was möchten Sie noch wissen?',
        portuguese: 'Esta cidade tem tanto a oferecer! De museus a belos parques, você vai adorar. O que mais você gostaria de saber?',
        nextHints: [
          'Wie funktioniert der öffentliche Nahverkehr?|Como funciona o transporte público?',
          'Gibt es kostenlose Museen?|Há algum museu gratuito?',
          'Danke für diese hilfreichen Tipps!|Obrigado por estas dicas úteis!'
        ],
      );
    } 
    
    else if (topicId == 'casual') { // casual chat
      if (cleanMsg.contains('brasil') || cleanMsg.contains('brazil') || cleanMsg.contains('from') || cleanMsg.contains('aus')) {
        return const AiResponse(
          english: 'Ah, Brasilien! Was für ein schönes und warmes Land. Das Wetter dort ist so anders als in Deutschland! Wie lange lernen Sie schon Deutsch?',
          portuguese: 'Ah, o Brasil! Que país maravilhoso e caloroso. O clima lá é bem diferente da Alemanha! Há quanto tempo você estuda alemão?',
          nextHints: [
            'Ich lerne seit einigen Monaten.|Estudo há alguns meses.',
            'Dies ist meine erste Woche beim Lernen.|Esta é minha primeira semana aprendendo.',
            'Ich lerne, um ins Ausland zu reisen.|Estou estudando para viajar para o exterior.'
          ],
        );
      }
      if (cleanMsg.contains('gut') || cleanMsg.contains('well') || cleanMsg.contains('hallo') || cleanMsg.contains('hello') || cleanMsg.contains('wie')) {
        return const AiResponse(
          english: 'Das freut mich zu hören! Mir geht es auch sehr gut. Was machen Sie gerne in Ihrer Freizeit? Haben Sie Hobbies oder Sportarten?',
          portuguese: 'Fico feliz em ouvir isso! Eu também estou muito bem. O que você gosta de fazer no seu tempo livre? Algum hobby ou esporte?',
          nextHints: [
            'Ich höre gerne Musik und lese.|Gosto de ouvir música e ler.',
            'Ich spiele Fußball mit meinen Freunden.|Jogo futebol com meus amigos.',
            'Ich schaue lieber Filme und Serien.|Prefiro assistir a filmes e séries.'
          ],
        );
      }
      if (cleanMsg.contains('months') || cleanMsg.contains('years') || cleanMsg.contains('monaten') || cleanMsg.contains('jahren') || cleanMsg.contains('zeit')) {
        return const AiResponse(
          english: 'Das ist fantastisch! Ihre Aussprache ist bereits sehr gut. Jeden Tag ein bisschen zu üben ist der Schlüssel. Was ist Ihr Ziel mit Deutsch?',
          portuguese: 'Isso é fantastico! Sua pronúncia já é muito boa. Praticar um pouco todo dia é a chave. Qual é o seu objetivo com o alemão?',
          nextHints: [
            'Ich möchte an einer deutschen Universität studieren.|Quero estudar em uma universidade alemã.',
            'Mein Traum ist, nach Berlin zu reisen.|Meu sonho é viajar para Berlim.',
            'Ich möchte einfach fließend sprechen können.|Eu só quero falar fluentemente.'
          ],
        );
      }
      // Default casual response
      return const AiResponse(
        english: 'Wie interessant! Eine neue Sprache zu sprechen öffnet so viele Türen. Möchten Sie weiter darüber sprechen?',
        portuguese: 'Que interessante! Falar uma nova língua abre tantas portas. Gostaria de continuar falando sobre isso?',
        nextHints: [
          'Ja, lassen Sie uns bitte weiterreden.|Sim, vamos continuar conversando, por favor.',
          'Ich habe eine andere Frage.|Tenho outra pergunta.',
          'Danke für das Gespräch!|Obrigado pela conversa!'
        ],
      );
    } else if (topicId == 'aeroporto') {
      if (cleanMsg.contains('tourismus') || cleanMsg.contains('turismo') || cleanMsg.contains('urlaub') || cleanMsg.contains('besuch')) {
        return const AiResponse(
          english: 'Klasse! Genießen Sie Ihre Reise. Wie lange bleiben Sie?',
          portuguese: 'Ótimo! Aproveite sua viagem. Quanto tempo você vai ficar?',
          nextHints: [
            'Ich bleibe für zehn Tage.|Vou ficar por dez dias.',
            'Nur eine Woche.|Apenas uma semana.',
            'Ungefähr einen Monat.|Cerca de um mês.'
          ],
        );
      }
      if (cleanMsg.contains('tage') || cleanMsg.contains('wochen') || cleanMsg.contains('stay') || cleanMsg.contains('bleiben') || cleanMsg.contains('zeit')) {
        return const AiResponse(
          english: 'Perfekt. Wo werden Sie während Ihres Aufenthalts wohnen?',
          portuguese: 'Perfeito. Onde você ficará hospedado durante sua visita?',
          nextHints: [
            'In einem Hotel in der Innenstadt.|Em um hotel no centro.',
            'Im Haus meines Freundes.|Na casa do meu amigo.',
            'Ich habe eine Wohnung gemietet.|Aluguei um apartamento.'
          ],
        );
      }
      return const AiResponse(
        english: 'Alles klar. Bitte zeigen Sie mir Ihre Dokumente und Ihren Reisepass.',
        portuguese: 'Tudo bem. Por favor, mostre-me seus documentos e passaporte.',
        nextHints: [
          'Hier ist mein Reisepass.|Aqui está o meu passaporte.',
          'Ich bin als Tourist hier.|Estou visitando como turista.',
          'Okay, bitte sehr.|Tudo bem, aqui está.'
        ],
      );
    } else if (topicId == 'hotel') {
      if (cleanMsg.contains('alex') || cleanMsg.contains('reservierung') || cleanMsg.contains('reserva') || cleanMsg.contains('name')) {
        return const AiResponse(
          english: 'Ich habe Ihre Reservierung für ein Doppelzimmer gefunden. Könnten Sie bitte hier unterschreiben?',
          portuguese: 'Encontrei sua reserva para um quarto duplo. Você poderia assinar aqui, por favor?',
          nextHints: [
            'Klar, hier ist meine Unterschrift.|Claro, aqui está minha assinatura.',
            'Ist das Frühstück inklusive?|O café da manhã está incluso?',
            'Kann ich zwei Schlüssel haben?|Pode me dar duas chaves?'
          ],
        );
      }
      if (cleanMsg.contains('frühstück') || cleanMsg.contains('breakfast') || cleanMsg.contains('essen') || cleanMsg.contains('serviert')) {
        return const AiResponse(
          english: 'Das Frühstück wird von 7 bis 10 Uhr im Hauptspeisesaal serviert. Guten Appetit!',
          portuguese: 'O café da manhã é servido das 7h às 10h no salão de jantar principal. Bom apetite!',
          nextHints: [
            'Vielen Dank.|Muito obrigado.',
            'Ist es im ersten Stock?|É no primeiro andar?',
            'Wie lautet die Zimmernummer?|Qual é o número do quarto?'
          ],
        );
      }
      return const AiResponse(
        english: 'Hier ist Ihr Schlüssel. Ihr Zimmer hat die Nummer 302 im dritten Stock. Sagen Sie mir Bescheid, wenn Sie Hilfe mit dem Gepäck brauchen.',
        portuguese: 'Aqui está sua chave. Seu quarto é o 302 no terceiro andar. Diga-me se precisar de ajuda com as malas.',
        nextHints: [
          'Danke, ich gehe jetzt auf mein Zimmer.|Obrigado, vou para o meu quarto agora.',
          'Wo ist der Fahrstuhl?|Onde fica o elevador?',
          'Danke für die Hilfe.|Obrigado pela ajuda.'
        ],
      );
    } else if (topicId == 'compras') {
      if (cleanMsg.contains('größe') || cleanMsg.contains('medium') || cleanMsg.contains('hemd') || cleanMsg.contains('t-shirt') || cleanMsg.contains('m')) {
        return const AiResponse(
          english: 'Ja, wir haben es in Größe M. Möchten Sie es in der Umkleidekabine anprobieren?',
          portuguese: 'Sim, nós temos no tamanho M. Gostaria de provar no provador?',
          nextHints: [
            'Ja, wo ist die Umkleidekabine?|Sim, onde fica o provador?',
            'Nein, ich nehme es einfach so.|Não, eu vou levar.',
            'Haben Sie das auch in Blau?|Você tem em azul também?'
          ],
        );
      }
      if (cleanMsg.contains('how much') || cleanMsg.contains('cost') || cleanMsg.contains('preis') || cleanMsg.contains('kostet') || cleanMsg.contains('geld')) {
        return const AiResponse(
          english: 'Diese Jacke kostet fünfundvierzig Euro. Wir haben heute zehn Prozent Rabatt!',
          portuguese: 'Esta jaqueta custa quarenta e cinco euros. Temos dez por cento de desconto hoje!',
          nextHints: [
            'Klasse, ich kaufe sie.|Ótimo, vou comprar.',
            'Gibt es sie auch in anderen Farben?|Está disponível em outras cores?',
            'Das ist ein bisschen teuer.|Isso é um pouco caro.'
          ],
        );
      }
      return const AiResponse(
        english: 'Wir haben heute auch Angebote für Jeans und Schuhe. Schauen Sie sich gerne um.',
        portuguese: 'Também temos promoções de calças jeans e sapatos hoje. Sinta-se à vontade para dar uma olhada.',
        nextHints: [
          'Wo sind die Jeans?|Onde ficam as calças jeans?',
          'Akzeptieren Sie Bargeld?|Vocês aceitam dinheiro?',
          'Okay, ich schaue mal.|Tudo bem, deixe-me dar uma olhada.'
        ],
      );
    } else {
      // Conversa livre fallback
      return const AiResponse(
        english: 'Das ist ein tolles Gespräch. Sprich einfach weiter auf Deutsch und ich werde deine Fehler korrigieren, falls nötig.',
        portuguese: 'Esta é uma ótima conversa. Continue falando livremente em alemão e eu corrigirei seus erros se necessário.',
        nextHints: [
          'Ich möchte weiterreden.|Quero continuar conversando.',
          'Wie kann ich mein Deutsch verbessern?|Como posso melhorar meu alemão?',
          'Vielen Dank!|Muito obrigado!'
        ],
      );
    }
  }
}
