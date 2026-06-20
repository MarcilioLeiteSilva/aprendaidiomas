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
  Map<String, String> get initialMessage => getInitialMessage('Alejandra');
}

class AiResponse {
  final String spanish;
  final String portuguese;
  final List<String> nextHints;

  const AiResponse({
    required this.spanish,
    required this.portuguese,
    required this.nextHints,
  });
}

class AiChatService {
  static final List<AiTopic> topics = [
    const AiTopic(
      id: 'cafe',
      title: 'Pedindo no Café Espanhol ☕',
      description: 'Pratique pedir tapas, churros e interagir com o garçom em Madri.',
      icon: Icons.coffee_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Me llamo {TUTOR}. Bienvenido a la Chocolatería San Ginés. ¿Qué te sirvo hoy?',
        'pt': 'Olá! Eu me chamo {TUTOR}. Bem-vindo à Chocolatería San Ginés. O que posso lhe servir hoje?'
      },
      initialHints: [
        'Un chocolate con churros, por favor.|Um chocolate com churros, por favor.',
        '¿Qué me recomienda?|O que você recomenda?',
        'Quería un zumo de naranja.|Eu queria um suco de laranja.'
      ],
    ),
    const AiTopic(
      id: 'turismo',
      title: 'Explorando Madri e Turismo 🇪🇸',
      description: 'Pergunte direções, recomendações do Museu do Prado, Plaza Mayor e passeios.',
      icon: Icons.explore_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Me llamo {TUTOR}, tu guía local. ¿Cuál es tu próximo destino en Madrid?',
        'pt': 'Olá! Eu me chamo {TUTOR}, seu guia local. Qual é o seu próximo destino em Madri?'
      },
      initialHints: [
        '¿Dónde está la Plaza Mayor, por favor?|Onde fica a Plaza Mayor, por favor?',
        'Quiero visitar el Museo del Prado.|Quero visitar o Museu do Prado.',
        '¿Cuáles son los mejores lugares para comer tapas?|Quais são os melhores lugares para comer tapas?'
      ],
    ),
    const AiTopic(
      id: 'aeroporto',
      title: 'Imigração e Aeroporto ✈️',
      description: 'Pratique responder às perguntas do oficial de imigração, fazer check-in ou pedir ajuda com as malas.',
      icon: Icons.local_airport_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Bienvenido al control de inmigración. ¿Cuál es el motivo de su visita?',
        'pt': 'Olá! Bem-vindo ao controle de imigração. Qual é o motivo da sua visita?'
      },
      initialHints: [
        'Vengo por turismo.|Venho a turismo.',
        'Me quedaré por dos semanas.|Vou ficar por duas semanas.',
        'Voy a visitar a unos amigos.|Vou visitar alguns amigos.'
      ],
    ),
    const AiTopic(
      id: 'hotel',
      title: 'Check-in no Hotel 🏨',
      description: 'Pratique fazer check-in na recepção, confirmar sua reserva e pedir a senha do Wi-Fi.',
      icon: Icons.hotel_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Bienvenido a nuestro hotel. ¿Tiene una reserva a su nombre?',
        'pt': 'Olá! Bem-vindo ao nosso hotel. Você tem uma reserva em seu nome?'
      },
      initialHints: [
        'Sí, tengo una reserva a nombre de Alex.|Sim, tenho uma reserva em nome de Alex.',
        '¿A qué hora se sirve el desayuno?|A que horas é servido o café da manhã?',
        '¿Hay Wi-Fi gratuito en la habitación?|Tem Wi-Fi gratuito no quarto?'
      ],
    ),
    const AiTopic(
      id: 'compras',
      title: 'Compras na Loja 🛍️',
      description: 'Pratique pedir tamanhos diferentes de roupas, perguntar os preços e efetuar o pagamento.',
      icon: Icons.shopping_bag_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Bienvenido. Avísame si necesitas ayuda para encontrar alguna talla o color. ¿Buscas algo en especial?',
        'pt': 'Olá! Bem-vindo. Diga-me se precisar de ajuda para encontrar qualquer tamanho ou cor. Está procurando algo especial?'
      },
      initialHints: [
        'Solo estoy mirando, gracias.|Só estou olhando, obrigado.',
        '¿Tienen esta camisa en talla M?|Vocês têm esta camisa no tamanho M?',
        '¿Cuánto cuesta esta chaqueta?|Quanto custa esta jaqueta?'
      ],
    ),
    const AiTopic(
      id: 'casual',
      title: 'Conversa Casual e Amizade 👋',
      description: 'Fale sobre seus hobbies, de onde você é e o que está achando da Espanha.',
      icon: Icons.chat_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Encantado de conocerte. Me llamo {TUTOR}. ¿Cómo estás hoy?',
        'pt': 'Oi! Prazer em te conhecer. Eu me chamo {TUTOR}. Como você vai hoje?'
      },
      initialHints: [
        '¡Muy bien, gracias! ¿Y tú?|Tudo ótimo, obrigado! E você?',
        'Estoy un poco cansado, pero bien.|Estou um pouco cansado, mas tudo bem.',
        'Me llamo Alex y soy de Brasil.|Eu me chamo Alex e venho do Brasil.'
      ],
    ),
    const AiTopic(
      id: 'livre',
      title: 'Conversa Livre & Correções 💬',
      description: 'Converse livremente sobre qualquer assunto. O tutor corrigirá seus erros.',
      icon: Icons.psychology_rounded,
      initialMessageTemplate: {
        'en': '¡Hola! Me llamo {TUTOR}. ¡Hablemos de lo que quieras hoy! Siéntete libre de escribir frases, estoy aquí para corregir tus errores.',
        'pt': 'Olá! Eu me chamo {TUTOR}. Vamos conversar sobre o que você quiser hoje! Sinta-se à vontade para formar frases, estou aqui para corrigir seus erros.'
      },
      initialHints: [
        'Hoy estoy muy bien.|Hoje eu estou muito bem.',
        'Me gustaría hablar de mis pasatiempos.|Eu gostaria de falar sobre meus hobbies.',
        '¿Puedes ayudarme a practicar?|Você pode me ajudar a praticar?'
      ],
    ),
  ];

  // A simple rule-based local simulation that feels like real AI conversation
  static AiResponse generateResponse(String topicId, String userMessage) {
    final cleanMsg = userMessage.toLowerCase().trim();

    if (topicId == 'cafe') {
      if (cleanMsg.contains('recomenda') || cleanMsg.contains('recomienda') || cleanMsg.contains('recomendo') || cleanMsg.contains('aconseja')) {
        return const AiResponse(
          spanish: 'Te recomiendo nuestra especialidad: chocolate caliente espeso con churros crujientes recién hechos. ¡Es delicioso! ¿Quieres probarlo?',
          portuguese: 'Recomendo a nossa especialidade: chocolate quente espesso com churros crocantes feitos na hora. É delicioso! Quer experimentar?',
          nextHints: [
            'Sí, por favor, quiero uno.|Sim, por favor, eu quero um.',
            '¿Cuánto cuesta?|Quanto custa?',
            'No gracias, prefiero un té.|Não obrigado, prefiro um chá.'
          ],
        );
      }
      if (cleanMsg.contains('churros') || cleanMsg.contains('chocolate') || cleanMsg.contains('comer') || cleanMsg.contains('queria')) {
        return const AiResponse(
          spanish: '¡Excelente elección! Un chocolate con churros calentitos. ¿Deseas alguna bebida más para acompañar? ¿Un café con leche, tal vez?',
          portuguese: 'Excelente escolha! Um chocolate com churros quentinhos. Deseja mais alguma bebida para acompanhar? Um café com leite, talvez?',
          nextHints: [
            'Un café con leche, por favor.|Um café com leite, por favor.',
            'Un vaso de agua, por favor.|Um copo de água, por favor.',
            'No, eso es todo, gracias.|Não, é só isso, obrigado.'
          ],
        );
      }
      if (cleanMsg.contains('cuanto') || cleanMsg.contains('cuenta') || cleanMsg.contains('pagar') || cleanMsg.contains('cuesta')) {
        return const AiResponse(
          spanish: 'Serían seis euros con cincuenta en total. ¿Prefieres pagar con tarjeta o en efectivo?',
          portuguese: 'Seria seis euros e cinquenta no total. Você prefere pagar com cartão ou em dinheiro?',
          nextHints: [
            'Voy a pagar con tarjeta.|Vou pagar com cartão.',
            'Aquí tienes diez euros. Quédate con o cambio.|Aqui estão dez euros. Fique com o troco.',
            '¿Aceptan cheques?|Vocês aceitam cheques?'
          ],
        );
      }
      if (cleanMsg.contains('gracias') || cleanMsg.contains('buen') || cleanMsg.contains('adios') || cleanMsg.contains('luego')) {
        return const AiResponse(
          spanish: '¡De nada! Muchas gracias por tu visita y que tengas un excelente día en Madrid.',
          portuguese: 'De nada! Muito obrigado pela sua visita e tenha um excelente dia em Madri!',
          nextHints: [
            '¡Muchas gracias, adiós!|Muito obrigado, tchau!',
            '¡Hasta luego!|Até logo!',
            'Igualmente, buen día.|Igualmente, bom dia.'
          ],
        );
      }
      // Default cafe response
      return const AiResponse(
        spanish: '¡Entendido! Te lo traigo en un momento. ¿Deseas algo más con tu pedido?',
        portuguese: 'Anotado! Trago isso para você em um instante. Deseja algo mais com o seu pedido?',
        nextHints: [
          'No, eso es todo, gracias.|Não, é só isso, obrigado!',
          'Tráeme la cuenta, por favor.|Traga-me a conta, por favor.',
          '¿Me das un poco de azúcar?|Pode me dar um pouco de açúcar?'
        ],
      );
    } 
    
    else if (topicId == 'turismo') {
      if (cleanMsg.contains('plaza') || cleanMsg.contains('mayor') || cleanMsg.contains('sol')) {
        return const AiResponse(
          spanish: '¡La Plaza Mayor de Madrid es espectacular! Está en el centro histórico de la ciudad. Puedes ir en metro hasta la estación Sol. ¿Quieres visitarla?',
          portuguese: 'A Plaza Mayor de Madri é espetacular! Fica no centro histórico da cidade. Você pode ir de metrô até a estação Sol. Você quer visitá-la?',
          nextHints: [
            'Sí, quiero ir ahora mismo.|Sim, quero ir agora mesmo.',
            '¿Qué más hay cerca de la Plaza Mayor?|O que mais tem perto da Plaza Mayor?',
            'Prefiero pasear por el Parque del Retiro.|Prefiro passear pelo Parque do Retiro.'
          ],
        );
      }
      if (cleanMsg.contains('prado') || cleanMsg.contains('museo') || cleanMsg.contains('meninas')) {
        return const AiResponse(
          spanish: '¡El Museo del Prado es inmenso! No olvides reservar tu entrada en línea con antelación para ver Las Meninas de Velázquez. ¿Ya tienes tu entrada?',
          portuguese: 'O Museu do Prado é imenso! Não se esqueça de reservar seu ingresso online com antecedência para ver Las Meninas de Velázquez. Você já tem seu ingresso?',
          nextHints: [
            'No, ¿dónde puedo comprarla?|Não, onde posso comprar?',
            'Sí, ya tengo mi reserva.|Sim, já tenho minha reserva.',
            '¿Qué otros museos me recomiendas?|Quais outros museus você me recomenda?'
          ],
        );
      }
      if (cleanMsg.contains('comer') || cleanMsg.contains('restaurante') || cleanMsg.contains('tapas') || cleanMsg.contains('hambre')) {
        return const AiResponse(
          spanish: 'Para comer, evita los restaurantes muy cerca de las atracciones turísticas principales. Ve a La Latina o a Malasaña para comer tapas auténticas y queso manchego. ¿Te gusta el queso?',
          portuguese: 'Para comer, evite os restaurantes perto das atrações turísticas principais. Vá para La Latina ou Malasaña para comer tapas autênticas e queijo manchego. Você gosta de queijo?',
          nextHints: [
            'Sí, ¡me encanta el queso manchego!|Sim, eu adoro queijo manchego!',
            '¿Qué platos típicos debo probar?|Quais pratos típicos devo provar?',
            'No, prefiero la comida italiana.|Não, prefiro comida italiana.'
          ],
        );
      }
      // Default turismo response
      return const AiResponse(
        spanish: '¡Madrid tiene tanto que ofrecer! Entre los museos, la Plaza de Oriente y el Parque del Retiro, te encantará. ¿Qué más quieres saber sobre la ciudad?',
        portuguese: 'Madri tem tanto a oferecer! Entre os museus, a Plaza de Oriente e o Parque do Retiro, você vai adorar. O que mais você gostaria de saber sobre a cidade?',
        nextHints: [
          '¿Cómo funciona el metro?|Como funciona o metrô?',
          '¿Hay parques gratuitos para visitar?|Há parques gratuitos para visitar?',
          'Gracias por estos valiosos consejos.|Obrigado por esses valiosos conselhos.'
        ],
      );
    } 
    
    else if (topicId == 'casual') { // casual chat
      if (cleanMsg.contains('brasil') || cleanMsg.contains('brasileño') || cleanMsg.contains('vienes')) {
        return const AiResponse(
          spanish: '¡Ah, Brasil! Qué país tan hermoso y acogedor. ¡El clima allí es muy diferente al de Madrid! ¿Desde cuándo estudias español?',
          portuguese: 'Ah, o Brasil! Que país maravilhoso e acolhedor. O clima lá é bem diferente de Madri! Há quanto tempo você estuda espanhol?',
          nextHints: [
            'Estudio español desde hace unos meses.|Estudo espanhol há alguns meses.',
            'Es mi primera semana aprendiendo.|É a minha primeira semana de aprendizado.',
            'Estudio para viajar a España.|Estou aprendendo para viajar para a Espanha.'
          ],
        );
      }
      if (cleanMsg.contains('bien') || cleanMsg.contains('hola') || cleanMsg.contains('como')) {
        return const AiResponse(
          spanish: '¡Me alegro de oírlo! Yo también estoy muy bien. ¿Qué te gusta hacer en tu tiempo libre? ¿Haces deporte o tocas música?',
          portuguese: 'Prazer em ouvir isso! Eu também vou muito bem. O que você gosta de fazer no tempo livre? Pratica esportes ou música?',
          nextHints: [
            'Me gusta escuchar música y leer.|Gosto de ouvir música e ler.',
            'Juego al fútbol con amigos.|Jogo futebol com amigos.',
            'Prefiero ver películas.|Prefiro assistir a filmes.'
          ],
        );
      }
      if (cleanMsg.contains('meses') || cleanMsg.contains('años') || cleanMsg.contains('tiempo')) {
        return const AiResponse(
          spanish: '¡Es fantástico! Tu pronunciación ya es muy buena. Practicar un poco cada día es el secreto del éxito. ¿Cuál es tu mayor sueño en España?',
          portuguese: 'Isso é fantástico! Sua pronúncia já é muito boa. Praticar um pouco todo dia é o segredo do sucesso. Qual é o seu maior sonho na Espanha?',
          nextHints: [
            'Quiero estudiar en una universidad española.|Quero estudar em uma universidade espanhola.',
            'Mi sueño es visitar Madrid y Barcelona.|Meu sonho é visitar Madri e Barcelona.',
            'Solo quiero hablar con fluidez.|Eu só quero falar fluentemente.'
          ],
        );
      }
      // Default casual response
      return const AiResponse(
        spanish: '¡Qué interesante! Hablar un nuevo idioma abre muchas puertas. ¿Te gustaría que sigamos conversando sobre esto?',
        portuguese: 'Isso é muito interessante! Falar uma nova língua abre tantas portas. Gostaria de continuar conversando sobre isso?',
        nextHints: [
          'Sí, sigamos hablando, por favor.|Sim, vamos continuar conversando, por favor.',
          'Tengo otra pregunta.|Tenho outra pergunta.',
          '¡Gracias por la conversación!|Obrigado pela conversa!'
        ],
      );
    } else if (topicId == 'aeroporto') {
      if (cleanMsg.contains('turismo') || cleanMsg.contains('turista') || cleanMsg.contains('visit')) {
        return const AiResponse(
          spanish: '¡Excelente! Disfrute de su viaje. ¿Cuánto tiempo se quedará?',
          portuguese: 'Excelente! Aproveite sua viagem. Quanto tempo você vai ficar?',
          nextHints: [
            'Me quedaré diez días.|Vou ficar dez dias.',
            'Solo una semana.|Apenas uma semana.',
            'Cerca de un mes.|Cerca de um mês.'
          ],
        );
      }
      if (cleanMsg.contains('dias') || cleanMsg.contains('semana') || cleanMsg.contains('quedare') || cleanMsg.contains('tiempo')) {
        return const AiResponse(
          spanish: 'Perfecto. ¿Dónde se hospedará durante su visita?',
          portuguese: 'Perfeito. Onde você ficará hospedado durante sua visita?',
          nextHints: [
            'En un hotel en el centro.|Em um hotel no centro.',
            'En la casa de mi amigo.|Na casa do meu amigo.',
            'Alquilé un apartamento.|Aluguei um apartamento.'
          ],
        );
      }
      return const AiResponse(
        spanish: 'De acuerdo. Por favor, muéstreme sus documentos y pasaporte.',
        portuguese: 'Tudo bem. Por favor, mostre-me seus documentos e pasaporte.',
        nextHints: [
          'Aquí tiene mi pasaporte.|Aqui está o meu pasaporte.',
          'Vengo por turismo.|Venho a turismo.',
          'De acuerdo, aquí tiene.|Tudo bem, aqui está.'
        ],
      );
    } else if (topicId == 'hotel') {
      if (cleanMsg.contains('alex') || cleanMsg.contains('reserva') || cleanMsg.contains('nombre') || cleanMsg.contains('name')) {
        return const AiResponse(
          spanish: 'Encontré su reserva para una habitación doble. ¿Podría firmar aquí, por favor?',
          portuguese: 'Encontrei sua reserva para um quarto duplo. Você poderia assinar aqui, por favor?',
          nextHints: [
            'Claro, aquí está mi firma.|Claro, aqui está minha assinatura.',
            '¿El desayuno está incluido?|O café da manhã está incluso?',
            '¿Me da dos llaves?|Pode me dar duas chaves?'
          ],
        );
      }
      if (cleanMsg.contains('desayuno') || cleanMsg.contains('sirve') || cleanMsg.contains('serve') || cleanMsg.contains('servi')) {
        return const AiResponse(
          spanish: 'El desayuno se sirve de 7 a 10 AM en el comedor principal. ¡Buen provecho!',
          portuguese: 'O café da manhã é servido das 7h às 10h no salão de jantar principal. Bom apetite!',
          nextHints: [
            'Muchas gracias.|Muito obrigado.',
            '¿Está en el primer piso?|É no primeiro andar?',
            '¿Cuál es el número de la habitación?|Qual é o número do quarto?'
          ],
        );
      }
      return const AiResponse(
        spanish: 'Aquí tiene su llave. Su habitación es la 302 en el tercer piso. Avíseme si necesita ayuda con su equipaje.',
        portuguese: 'Aqui está sua chave. Seu quarto é o 302 no terceiro andar. Diga-me se precisar de ajuda com as malas.',
        nextHints: [
          'Gracias, voy a mi habitación ahora.|Obrigado, vou para o meu quarto agora.',
          '¿Dónde está el ascensor?|Onde fica o elevador?',
          'Gracias por la ayuda.|Obrigado pela ajuda.'
        ],
      );
    } else if (topicId == 'compras') {
      if (cleanMsg.contains('talla') || cleanMsg.contains('tamanho') || cleanMsg.contains('m') || cleanMsg.contains('medium')) {
        return const AiResponse(
          spanish: 'Sí, la tenemos en talla M. ¿Le gustaría probársela en el probador?',
          portuguese: 'Sim, nós temos no tamanho M. Gostaria de provar no provador?',
          nextHints: [
            'Sí, ¿dónde está el probador?|Sim, onde fica o provador?',
            'No, me la llevo directamente.|Não, vou levar direto.',
            '¿Tienen en azul también?|Vocês têm em azul também?'
          ],
        );
      }
      if (cleanMsg.contains('cuanto') || cleanMsg.contains('precio') || cleanMsg.contains('cost') || cleanMsg.contains('cuesta')) {
        return const AiResponse(
          spanish: 'Esta chaqueta cuesta cuarenta y cinco dólares. ¡Hoy tenemos un diez por ciento de descuento!',
          portuguese: 'Esta jaqueta custa quarenta e cinco dólares. Temos dez por cento de desconto hoje!',
          nextHints: [
            'Excelente, me la llevo.|Excelente, vou comprar.',
            '¿Está disponible en otros colores?|Está disponível em outras cores?',
            'Es un poco cara.|É um pouco cara.'
          ],
        );
      }
      return const AiResponse(
        spanish: 'También tenemos rebajas en jeans y zapatos hoy. Siéntase libre de mirar a su alrededor.',
        portuguese: 'Também temos promoções de calças jeans e sapatos hoje. Sinta-se à vontade para dar uma olhada.',
        nextHints: [
          '¿Dónde están los jeans?|Onde ficam as calças jeans?',
          '¿Aceptan efectivo?|Vocês aceitam dinheiro?',
          'De acuerdo, déjeme mirar.|Tudo bem, deixe-me dar uma olhada.'
        ],
      );
    } else {
      // Conversa livre fallback
      return const AiResponse(
        spanish: 'Esta es una excelente conversación. Sigue hablando libremente en español y corregiré tus errores si es necesario.',
        portuguese: 'Essa é uma ótima conversa. Continue falando livremente em espanhol e eu corrigirei seus erros se necessário.',
        nextHints: [
          'Quiero seguir hablando.|Quero continuar conversando.',
          '¿Cómo puedo mejorar?|Como posso melhorar?',
          '¡Muchas gracias!|Muito obrigado!'
        ],
      );
    }
  }
}
