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
  Map<String, String> get initialMessage => getInitialMessage('Giulia');
}

class AiResponse {
  final String italian;
  final String portuguese;
  final List<String> nextHints;

  const AiResponse({
    required this.italian,
    required this.portuguese,
    required this.nextHints,
  });
}

class AiChatService {
  static final List<AiTopic> topics = [
    const AiTopic(
      id: 'cafe',
      title: 'Pedindo no Café Italiano ☕',
      description: 'Pratique pedir cappuccino, cornetto e interagir com o garçom na Itália.',
      icon: Icons.coffee_rounded,
      initialMessageTemplate: {
        'en': 'Buongiorno! Mi chiamo {TUTOR}. Benvenuto al nostro bar. Cosa posso portarti oggi?',
        'pt': 'Bom dia! Eu me chamo {TUTOR}. Bem-vindo ao nosso café. O que posso lhe servir hoje?'
      },
      initialHints: [
        'Un cappuccino e un cornetto, per favore.|Um cappuccino e um croissant, por favor.',
        'Cosa mi consiglia?|O que você recomenda?',
        'Vorrei una tazza di caffè espresso.|Eu gostaria de uma xícara de café espresso.'
      ],
    ),
    const AiTopic(
      id: 'turismo',
      title: 'Explorando Roma ou Veneza 🇮🇹',
      description: 'Pergunte direções, recomendações do Coliseu, canais de Veneza e passeios.',
      icon: Icons.explore_rounded,
      initialMessageTemplate: {
        'en': 'Ciao! Mi chiamo {TUTOR}, la tua guida locale. Qual è la tua prossima destinazione in Italia?',
        'pt': 'Olá! Eu me chamo {TUTOR}, seu guia local. Qual é o seu próximo destino na Itália?'
      },
      initialHints: [
        'Dov\'è il Colosseo, per favore?|Onde fica o Coliseu, por favor?',
        'Voglio visitare i canali di Venezia.|Quero visitar os canais de Veneza.',
        'Quali sono i migliori ristoranti qui vicino?|Quais são os melhores restaurantes aqui perto?'
      ],
    ),
    const AiTopic(
      id: 'aeroporto',
      title: 'Imigração e Aeroporto ✈️',
      description: 'Pratique responder às perguntas do oficial de imigração, fazer check-in ou pedir ajuda com as malas.',
      icon: Icons.local_airport_rounded,
      initialMessageTemplate: {
        'en': 'Buongiorno! Benvenuto al controllo immigrazione. Qual è il motivo della tua visita?',
        'pt': 'Olá! Bem-vindo ao controle de imigração. Qual é o motivo da sua visita?'
      },
      initialHints: [
        'Vengo per turismo.|Venho a turismo.',
        'Rimarrò per due settimane.|Vou ficar por duas semanas.',
        'Vado a visitare degli amici.|Vou visitar alguns amigos.'
      ],
    ),
    const AiTopic(
      id: 'hotel',
      title: 'Check-in no Hotel 🏨',
      description: 'Pratique fazer check-in na recepção, confirmar sua reserva e pedir a senha do Wi-Fi.',
      icon: Icons.hotel_rounded,
      initialMessageTemplate: {
        'en': 'Buongiorno! Benvenuto nel nostro hotel. Ha una prenotazione a suo nome?',
        'pt': 'Olá! Bem-vindo ao nosso hotel. Você tem uma reserva em seu nome?'
      },
      initialHints: [
        'Sì, ho una prenotazione a nome di Alex.|Sim, tenho uma reserva em nome de Alex.',
        'A che ora viene servita la colazione?|A que horas é servido o café da manhã?',
        'C\'è il Wi-Fi gratuito in camera?|Tem Wi-Fi gratuito no quarto?'
      ],
    ),
    const AiTopic(
      id: 'compras',
      title: 'Compras na Loja 🛍️',
      description: 'Pratique pedir tamanhos diferentes de roupas, perguntar os preços e efetuar o pagamento.',
      icon: Icons.shopping_bag_rounded,
      initialMessageTemplate: {
        'en': 'Ciao! Benvenuto. Fammi sapere se hai bisogno di aiuto per trovare una taglia o un colore. Cerchi qualcosa di particolare?',
        'pt': 'Olá! Bem-vindo. Diga-me se precisar de ajuda para encontrar qualquer tamanho ou cor. Está procurando algo especial?'
      },
      initialHints: [
        'Sto solo guardando, grazie.|Só estou olhando, obrigado.',
        'Ha questa camicia in taglia M?|Você tem esta camisa no tamanho M?',
        'Quanto costa questa giacca?|Quanto custa esta jaqueta?'
      ],
    ),
    const AiTopic(
      id: 'casual',
      title: 'Conversa Casual e Amizade 👋',
      description: 'Fale sobre seus hobbies, de onde você é e o que está achando da Itália.',
      icon: Icons.chat_rounded,
      initialMessageTemplate: {
        'en': 'Ciao! Piacere di conoscerti. Mi chiamo {TUTOR}. Come stai oggi?',
        'pt': 'Oi! Prazer em te conhecer. Eu me chamo {TUTOR}. Como você vai hoje?'
      },
      initialHints: [
        'Molto bene, grazie! E tu?|Tudo ótimo, obrigado! E você?',
        'Sono un po\' stanco, ma sto bene.|Estou um pouco cansado, mas tudo bem.',
        'Mi chiamo Alex e vengo dal Brasile.|Eu me chamo Alex e venho do Brasil.'
      ],
    ),
    const AiTopic(
      id: 'livre',
      title: 'Conversa Livre & Correções 💬',
      description: 'Converse livremente sobre qualquer assunto. O tutor corrigirá seus erros.',
      icon: Icons.psychology_rounded,
      initialMessageTemplate: {
        'en': 'Buongiorno! Mi chiamo {TUTOR}. Parliamo di quello che vuoi hoje! Sentiti libero di scrivere frasi, sono qui per correggere i tuoi errori.',
        'pt': 'Olá! Eu me chamo {TUTOR}. Vamos conversar sobre o que você quiser hoje! Sinta-se à vontade para formar frases, estou aqui para corrigir seus erros.'
      },
      initialHints: [
        'Oggi sto molto bene.|Hoje eu estou muito bem.',
        'Vorrei parlare dei miei hobby.|Eu gostaria de falar sobre meus hobbies.',
        'Puoi aiutarmi a fare pratica?|Você pode me ajudar a praticar?'
      ],
    ),
  ];

  // A simple rule-based local simulation that feels like real AI conversation
  static AiResponse generateResponse(String topicId, String userMessage) {
    final cleanMsg = userMessage.toLowerCase().trim();

    if (topicId == 'cafe') {
      if (cleanMsg.contains('consiglia') || cleanMsg.contains('recomenda') || cleanMsg.contains('recomendo') || cleanMsg.contains('suggerisce')) {
        return const AiResponse(
          italian: 'Ti consiglio la nostra specialità: un cappuccino cremoso con un cornetto caldo alla crema. È delizioso! Vuoi provarlo?',
          portuguese: 'Recomendo a nossa especialidade: um cappuccino cremoso com um croissant quente de creme. É delicioso! Quer experimentar?',
          nextHints: [
            'Sì, per favore, ne vorrei uno.|Sim, por favor, eu quero um.',
            'Quanto costa?|Quanto custa?',
            'No grazie, preferisco un tè.|Não obrigado, prefiro um chá.'
          ],
        );
      }
      if (cleanMsg.contains('cornetto') || cleanMsg.contains('caffè') || cleanMsg.contains('espresso') || cleanMsg.contains('mangiare') || cleanMsg.contains('voglio')) {
        return const AiResponse(
          italian: 'Ottima scelta! Un cornetto caldo e un caffè fresco. Desideri qualcos\'altro da bere? Un bicchiere di succo d\'arancia, forse?',
          portuguese: 'Excelente escolha! Um croissant quentinho e um café fresco. Deseja algo mais para beber? Um copo de suco de laranja, talvez?',
          nextHints: [
            'Un bicchiere di succo d\'arancia, per favore.|Um copo de suco de laranja, por favor.',
            'Un bicchiere d\'acqua, per favore.|Um copo de água, por favor.',
            'No, a posto così, grazie.|Não, é só isso, obrigado.'
          ],
        );
      }
      if (cleanMsg.contains('quanto costa') || cleanMsg.contains('conto') || cleanMsg.contains('pagare') || cleanMsg.contains('costa')) {
        return const AiResponse(
          italian: 'In totale sono sei euro e cinquanta centesimi. Preferisce pagare con carta o in contanti?',
          portuguese: 'Fica seis euros e cinquenta no total. Você prefere pagar com cartão ou em dinheiro?',
          nextHints: [
            'Pago con la carta.|Vou pagar com cartão.',
            'Ecco dieci euro. Tenga il resto.|Aqui estão dez euros. Fique com o troco.',
            'Posso pagare con carta di credito?|Posso pagar com cartão de crédito?'
          ],
        );
      }
      if (cleanMsg.contains('grazie') || cleanMsg.contains('ciao') || cleanMsg.contains('giornata')) {
        return const AiResponse(
          italian: 'Prego! Grazie per la visita e buona giornata!',
          portuguese: 'De nada! Muito obrigado pela visita e tenha um ótimo dia!',
          nextHints: [
            'Grazie mille, arrivederci!|Muito obrigado, tchau!',
            'A presto!|Até logo!',
            'Anche a lei, buona giornata.|Igualmente, tenha um bom dia.'
          ],
        );
      }
      // Default cafe response
      return const AiResponse(
          italian: 'Va bene! Te lo porto subito. Desideri qualcos\'altro con il tuo ordine?',
        portuguese: 'Anotado! Trago isso para você em um instante. Deseja algo mais com o seu pedido?',
        nextHints: [
          'No, a posto così, grazie.|Não, é só isso, obrigado!',
          'Mi porta il conto, per favore.|Traga-me a conta, por favor.',
          'Posso avere dello zucchero?|Pode me trazer açúcar?'
        ],
      );
    } 
    
    else if (topicId == 'turismo') {
      if (cleanMsg.contains('colosseo') || cleanMsg.contains('roma') || cleanMsg.contains('metro')) {
        return const AiResponse(
          italian: 'Il Colosseo è meraviglioso! Si trova nel centro di Roma. Puoi prendere la metro Linea B e scendere alla stazione Colosseo. Hai già fatto il biglietto?',
          portuguese: 'O Coliseu é maravilhoso! Fica no centro de Roma. Você pode pegar a Linha B do metrô e descer na estação Colosseo. Você já comprou o ingresso?',
          nextHints: [
            'Sì, ho già il biglietto.|Sim, já tenho o ingresso.',
            'No, dove posso comprarlo?|Não, onde posso comprar?',
            'Quanto costa un biglietto singolo?|Quanto custa um bilhete único?'
          ],
        );
      }
      if (cleanMsg.contains('venezia') || cleanMsg.contains('canali') || cleanMsg.contains('giro')) {
        return const AiResponse(
          italian: 'Venezia è unica al mondo! Ti consiglio di fare un giro in gondola o prendere il vaporetto per navigare sul Canal Grande. Ci sei già stato?',
          portuguese: 'Veneza é única no mundo! Recomendo fazer um passeio de gôndola ou pegar o vaporetto para navegar no Grande Canal. Você já esteve lá?',
          nextHints: [
            'No, è la mia prima volta.|Não, é a minha primeira vez.',
            'Sì, ci sono stato l\'anno scorso.|Sim, estive lá no ano passado.',
            'Quali altre attrazioni mi consiglia?|Quais outras atrações você recomenda?'
          ],
        );
      }
      if (cleanMsg.contains('mangiare') || cleanMsg.contains('ristorante') || cleanMsg.contains('cibo') || cleanMsg.contains('fame')) {
        return const AiResponse(
          italian: 'Per mangiare del vero cibo italiano, evita i ristoranti turistici. Cerca una trattoria locale per assaggiare la pasta alla carbonara o la pizza napoletana. Ti piace la pasta?',
          portuguese: 'Para comer comida italiana de verdade, evite restaurantes turísticos. Procure uma trattoria local para provar a pasta à carbonara ou a pizza napolitana. Você gosta de massa?',
          nextHints: [
            'Sì, adoro la pasta!|Sim, eu adoro massa!',
            'Quali altri piatti tipici devo provare?|Quais outros pratos típicos devo provar?',
            'No, preferisco il gelato.|Não, eu prefiro sorvete.'
          ],
        );
      }
      // Default turismo response
      return const AiResponse(
        italian: 'L\'Italia ha così tanto da offrire! Tra storia, arte e paesaggi splendidi, ti piacerà moltissimo. Cosa altro vorresti sapere?',
        portuguese: 'A Itália tem tanto a oferecer! Entre história, arte e belas paisagens, você vai adorar. O que mais gostaria de saber?',
        nextHints: [
          'Come funziona il trasporto pubblico?|Como funciona o transporte público?',
          'Ci sono musei gratuiti da visitare?|Há algum museu gratuito para visitar?',
          'Grazie per questi consigli utili!|Obrigado por estas dicas úteis!'
        ],
      );
    } 
    
    else if (topicId == 'casual') { // casual chat
      if (cleanMsg.contains('brasile') || cleanMsg.contains('brasil') || cleanMsg.contains('vengo')) {
        return const AiResponse(
          italian: 'Ah, il Brasile! Che paese bellissimo e caloroso. Il clima lì è molto diverso da quello italiano! Da quanto tempo studi l\'italiano?',
          portuguese: 'Ah, o Brasil! Que país maravilhoso e caloroso. O clima lá é bem diferente do italiano! Há quanto tempo você estuda italiano?',
          nextHints: [
            'Studio l\'italiano da pochi mesi.|Estudo italiano há alguns meses.',
            'Questa è la mia prima settimana di studio.|Esta é minha primeira semana de aprendizado.',
            'Studio per viaggiare in Italia.|Estou estudando para viajar para a Itália.'
          ],
        );
      }
      if (cleanMsg.contains('bene') || cleanMsg.contains('ciao') || cleanMsg.contains('come')) {
        return const AiResponse(
          italian: 'Mi fa piacere sentirlo! Anche io sto molto bene. Cosa ti piace fare nel tempo libero? Hai qualche hobby o sport?',
          portuguese: 'Fico feliz em ouvir isso! Eu também estou muito bem. O que você gosta de fazer no seu tempo livre? Algum hobby ou esporte?',
          nextHints: [
            'Mi piace ascoltare musica e leggere.|Gosto de ouvir música e ler.',
            'Gioco a calcio con i miei amici.|Jogo futebol com meus amigos.',
            'Preferisco guardare film e serie TV.|Prefiro assistir a filmes e séries de TV.'
          ],
        );
      }
      if (cleanMsg.contains('mesi') || cleanMsg.contains('anni') || cleanMsg.contains('tempo')) {
        return const AiResponse(
          italian: 'È fantastico! La tua pronuncia è già molto buona. Esercitarsi un po\' ogni giorno è la chiave del successo. Qual è il tuo obiettivo con l\'italiano?',
          portuguese: 'Isso é fantástico! Sua pronúncia já é muito boa. Praticar um pouco todo dia é a chave do sucesso. Qual é o seu objetivo com o italiano?',
          nextHints: [
            'Voglio studiare in un\'università italiana.|Quero estudar em uma universidade italiana.',
            'Il mio sogno è visitare Roma e Firenze.|Meu sonho é viajar para Roma e Florença.',
            'Voglio solo parlare correntemente.|Eu só quero falar fluentemente.'
          ],
        );
      }
      // Default casual response
      return const AiResponse(
        italian: 'Che interessante! Parlare una nuova lingua apre così tante porte. Ti andrebbe di continuare a parlarne?',
        portuguese: 'Que interessante! Falar uma nova língua abre tantas portas. Gostaria de continuar conversando sobre isso?',
        nextHints: [
          'Sì, continuiamo a parlare, per favore.|Sim, vamos continuar conversando, por favor.',
          'Ho un\'altra domanda.|Tenho outra pergunta.',
          'Grazie per la conversazione!|Obrigado pela conversa!'
        ],
      );
    } else if (topicId == 'aeroporto') {
      if (cleanMsg.contains('turismo') || cleanMsg.contains('turista') || cleanMsg.contains('visita')) {
        return const AiResponse(
          italian: 'Ottimo! Ti auguro un buon viaggio. Quanto tempo rimarrai?',
          portuguese: 'Excelente! Aproveite sua viagem. Quanto tempo você vai ficar?',
          nextHints: [
            'Rimarrò per dieci giorni.|Vou ficar dez dias.',
            'Solo una settimana.|Apenas uma semana.',
            'Circa un mese.|Cerca de um mês.'
          ],
        );
      }
      if (cleanMsg.contains('giorni') || cleanMsg.contains('settimana') || cleanMsg.contains('settimane') || cleanMsg.contains('rimango')) {
        return const AiResponse(
          italian: 'Perfetto. Dove alloggerai durante la tua visita?',
          portuguese: 'Perfeito. Onde você ficará hospedado durante sua visita?',
          nextHints: [
            'In un hotel in centro.|Em um hotel no centro.',
            'A casa di un amico.|Na casa de um amigo.',
            'Ho affittato un appartamento.|Aluguei um apartamento.'
          ],
        );
      }
      return const AiResponse(
        italian: 'Va bene. Per favore, mi mostri i suoi documenti e il passaporto.',
        portuguese: 'Tudo bem. Por favor, mostre-me seus documentos e passaporte.',
        nextHints: [
          'Ecco il mio passaporto.|Aqui está o meu passaporte.',
          'Vengo in visita come turista.|Venho visitar como turista.',
          'Va bene, ecco qui.|Tudo bem, aqui está.'
        ],
      );
    } else if (topicId == 'hotel') {
      if (cleanMsg.contains('alex') || cleanMsg.contains('prenotazione') || cleanMsg.contains('reserva') || cleanMsg.contains('nome')) {
        return const AiResponse(
          italian: 'Ho trovato la sua prenotazione per una camera doppia. Potrebbe firmare qui, per favore?',
          portuguese: 'Encontrei sua reserva para um quarto duplo. Você poderia assinar aqui, por favor?',
          nextHints: [
            'Certo, ecco la mia firma.|Claro, aqui está minha assinatura.',
            'La colazione è inclusa?|O café da manhã está incluso?',
            'Posso avere due chiavi?|Pode me dar duas chaves?'
          ],
        );
      }
      if (cleanMsg.contains('colazione') || cleanMsg.contains('servita') || cleanMsg.contains('ora') || cleanMsg.contains('mangiare')) {
        return const AiResponse(
          italian: 'La colazione viene servita dalle 7 alle 10 nella sala da pranzo principale. Buon appetito!',
          portuguese: 'O café da manhã é servido das 7h às 10h no salão de jantar principal. Bom apetite!',
          nextHints: [
            'Grazie mille.|Muito obrigado.',
            'È al primo piano?|É no primeiro andar?',
            'Qual è il numero di camera?|Qual é o número do quarto?'
          ],
        );
      }
      return const AiResponse(
        italian: 'Ecco la sua chiave. La sua camera è la numero 302 al terzo piano. Mi faccia sapere se ha bisogno di aiuto con i bagagli.',
        portuguese: 'Aqui está sua chave. Seu quarto é o 302 no terceiro andar. Diga-me se precisar de ajuda com as malas.',
        nextHints: [
          'Grazie, vado in camera adesso.|Obrigado, vou para o meu quarto agora.',
          'Dov\'è l\'ascensore?|Onde fica o elevador?',
          'Grazie per l\'aiuto.|Obrigado pela ajuda.'
        ],
      );
    } else if (topicId == 'compras') {
      if (cleanMsg.contains('taglia') || cleanMsg.contains('tamanho') || cleanMsg.contains('m') || cleanMsg.contains('media')) {
        return const AiResponse(
          italian: 'Sì, ce l\'abbiamo in taglia M. Le andrebbe di provarla in camerino?',
          portuguese: 'Sim, nós temos no tamanho M. Gostaria de provar no provador?',
          nextHints: [
            'Sì, dov\'è il camerino?|Sim, onde fica o provador?',
            'No, la prendo così.|Não, eu vou levar.',
            'Ce l\'ha anche in blu?|Você tem em azul também?'
          ],
        );
      }
      if (cleanMsg.contains('quanto costa') || cleanMsg.contains('prezzo') || cleanMsg.contains('costo') || cleanMsg.contains('costa')) {
        return const AiResponse(
          italian: 'Questa giacca costa quarantacinque euro. Oggi abbiamo uno sconto del dieci percento!',
          portuguese: 'Esta jaqueta custa quarenta e cinco euros. Temos dez por cento de desconto hoje!',
          nextHints: [
            'Ottimo, la compro.|Ótimo, vou comprar.',
            'È disponibile in altri colori?|Está disponível em outras cores?',
            'È un po\' cara.|É um pouco cara.'
          ],
        );
      }
      return const AiResponse(
        italian: 'Oggi abbiamo anche sconti su jeans e scarpe. Si senta libero di dare un\'occhiata in giro.',
        portuguese: 'Também temos promoções de calças jeans e sapatos hoje. Sinta-se à vontade para dar uma olhada.',
        nextHints: [
          'Dove sono i jeans?|Onde ficam as calças jeans?',
          'Accetta contanti?|Você aceita dinheiro?',
          'Va bene, do un\'occhiata.|Tudo bem, deixe-me dar uma olhada.'
        ],
      );
    } else {
      // Conversa livre fallback
      return const AiResponse(
        italian: 'Questa è una bella conversazione. Continua a parlare liberamente in italiano e correggerò i tuoi errori se necessario.',
        portuguese: 'Essa é uma ótima conversa. Continue falando livremente em italiano e eu corrigirei seus erros se necessário.',
        nextHints: [
          'Voglio continuare a parlare.|Quero continuar conversando.',
          'Come posso migliorare il mio italiano?|Como posso melhorar meu italiano?',
          'Grazie mille!|Muito obrigado!'
        ],
      );
    }
  }
}
