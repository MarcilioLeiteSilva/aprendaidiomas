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
  Map<String, String> get initialMessage => getInitialMessage('Emily');
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
      title: 'Pedindo no Café Inglês ☕',
      description: 'Pratique pedir um café, lanches e interagir com o garçom em Londres ou Nova York.',
      icon: Icons.coffee_rounded,
      initialMessageTemplate: {
        'en': 'Hello! My name is {TUTOR}. Welcome to our coffee shop. What can I get you today?',
        'pt': 'Olá! Eu me chamo {TUTOR}. Bem-vindo ao nosso café. O que posso lhe servir hoje?'
      },
      initialHints: [
        'A cup of coffee, please.|Um copo de café, por favor.',
        'What do you recommend?|O que você recomenda?',
        'I would like a muffin.|Eu gostaria de um muffin.'
      ],
    ),
    const AiTopic(
      id: 'turismo',
      title: 'Explorando Londres ou NY 🇬🇧',
      description: 'Pergunte direções, recomendações do Big Ben, Central Park ou pontos turísticos.',
      icon: Icons.explore_rounded,
      initialMessageTemplate: {
        'en': 'Hello! My name is {TUTOR}, your local guide. What is your next destination in the city?',
        'pt': 'Olá! Eu me chamo {TUTOR}, seu guia local. Qual é o seu próximo destino na cidade?'
      },
      initialHints: [
        'Where is the nearest subway station, please?|Onde fica a estação de metrô mais próxima, por favor?',
        'I want to visit Central Park.|Quero visitar o Central Park.',
        'What are the best places to eat nearby?|Quais são os melhores lugares para comer por perto?'
      ],
    ),
    const AiTopic(
      id: 'aeroporto',
      title: 'Imigração e Aeroporto ✈️',
      description: 'Pratique responder às perguntas do oficial de imigração, fazer check-in ou pedir ajuda com as malas.',
      icon: Icons.local_airport_rounded,
      initialMessageTemplate: {
        'en': 'Hello! Welcome to the immigration counter. What is the purpose of your visit?',
        'pt': 'Olá! Bem-vindo ao balcão de imigração. Qual é o propósito da sua visita?'
      },
      initialHints: [
        'I am here for tourism.|Estou aqui a turismo.',
        'I will stay for two weeks.|Vou ficar por duas semanas.',
        'I am visiting some friends.|Estou visitando alguns amigos.'
      ],
    ),
    const AiTopic(
      id: 'hotel',
      title: 'Check-in no Hotel 🏨',
      description: 'Pratique fazer check-in na recepção, confirmar sua reserva e pedir a senha do Wi-Fi.',
      icon: Icons.hotel_rounded,
      initialMessageTemplate: {
        'en': 'Hello! Welcome to our hotel. Do you have a reservation under your name?',
        'pt': 'Olá! Bem-vindo ao nosso hotel. Você tem uma reserva em seu nome?'
      },
      initialHints: [
        'Yes, my reservation is under the name Alex.|Sim, minha reserva está sob o nome Alex.',
        'What time is breakfast served?|Que horas o café da manhã é servido?',
        'Is there free Wi-Fi in the room?|Tem Wi-Fi gratuito no quarto?'
      ],
    ),
    const AiTopic(
      id: 'compras',
      title: 'Compras na Loja 🛍️',
      description: 'Pratique pedir tamanhos diferentes de roupas, perguntar os preços e efetuar o pagamento.',
      icon: Icons.shopping_bag_rounded,
      initialMessageTemplate: {
        'en': 'Hi there! Welcome. Let me know if you need help finding any size or color. Are you looking for something specific?',
        'pt': 'Olá! Bem-vindo. Diga-me se precisar de ajuda para encontrar qualquer tamanho ou cor. Está procurando algo específico?'
      },
      initialHints: [
        'I am just looking, thank you.|Só estou dando uma olhadinha, obrigado.',
        'Do you have this shirt in a medium size?|Você tem essa camisa no tamanho M?',
        'How much does this jacket cost?|Quanto custa esta jaqueta?'
      ],
    ),
    const AiTopic(
      id: 'casual',
      title: 'Conversa Casual e Amizade 👋',
      description: 'Fale sobre seus hobbies, de onde você é e o que está achando da cidade.',
      icon: Icons.chat_rounded,
      initialMessageTemplate: {
        'en': 'Hello! Nice to meet you. My name is {TUTOR}. How are you doing today?',
        'pt': 'Oi! Prazer em te conhecer. Eu me chamo {TUTOR}. Como você vai hoje?'
      },
      initialHints: [
        'I am doing great, thank you! And you?|Estou ótimo, obrigado! E você?',
        'I am a bit tired, but good.|Estou um pouco cansado, mas bem.',
        'My name is Alex and I am from Brazil.|Meu nome é Alex e sou do Brasil.'
      ],
    ),
    const AiTopic(
      id: 'livre',
      title: 'Conversa Livre & Correções 💬',
      description: 'Converse livremente sobre qualquer assunto. O tutor corrigirá seus erros.',
      icon: Icons.psychology_rounded,
      initialMessageTemplate: {
        'en': 'Hello! My name is {TUTOR}. Let\'s talk about whatever you want today! Feel free to write sentences, I am here to correct your mistakes.',
        'pt': 'Olá! Eu me chamo {TUTOR}. Vamos conversar sobre o que você quiser hoje! Sinta-se à vontade para formar frases, estou aqui para corrigir seus erros.'
      },
      initialHints: [
        'I am doing very well today.|Hoje eu estou muito bem.',
        'I would like to talk about my hobbies.|Eu gostaria de falar sobre meus hobbies.',
        'Can you help me practice?|Você pode me ajudar a praticar?'
      ],
    ),
  ];

  // A simple rule-based local simulation that feels like real AI conversation
  static AiResponse generateResponse(String topicId, String userMessage) {
    final cleanMsg = userMessage.toLowerCase().trim();

    if (topicId == 'cafe') {
      if (cleanMsg.contains('recommend') || cleanMsg.contains('recomenda') || cleanMsg.contains('recomendo') || cleanMsg.contains('suggest')) {
        return const AiResponse(
          english: 'I recommend our specialty: hot chocolate with freshly baked muffins. It is delicious! Would you like to try it?',
          portuguese: 'Recomendo a nossa especialidade: chocolate quente com muffins assados na hora. É delicioso! Você gostaria de experimentar?',
          nextHints: [
            'Yes, please, I want one.|Sim, por favor, eu quero um.',
            'How much does it cost?|Quanto custa?',
            'No thanks, I prefer a tea.|Não obrigado, prefiro um chá.'
          ],
        );
      }
      if (cleanMsg.contains('muffin') || cleanMsg.contains('coffee') || cleanMsg.contains('eat') || cleanMsg.contains('want')) {
        return const AiResponse(
          english: 'Excellent choice! A warm muffin and fresh coffee. Would you like anything else to drink? A glass of juice, perhaps?',
          portuguese: 'Excelente escolha! Um muffin quentinho e café fresco. Você gostaria de algo mais para beber? Um copo de suco, talvez?',
          nextHints: [
            'A glass of orange juice, please.|Um copo de suco de laranja, por favor.',
            'A bottle of water, please.|Uma garrafa de água, por favor.',
            'No, that is all, thanks.|Não, é só isso, obrigado.'
          ],
        );
      }
      if (cleanMsg.contains('how much') || cleanMsg.contains('bill') || cleanMsg.contains('pay') || cleanMsg.contains('cost')) {
        return const AiResponse(
          english: 'It will be six dollars and fifty cents in total. Do you prefer paying by card or cash?',
          portuguese: 'Fica seis dólares e cinquenta no total. Você prefere pagar com cartão ou em dinheiro?',
          nextHints: [
            'I will pay by card.|Vou pagar com cartão.',
            'Here is ten dollars. Keep the change.|Aqui estão dez dólares. Fique com o troco.',
            'Can I pay with credit card?|Posso pagar com cartão de crédito?'
          ],
        );
      }
      if (cleanMsg.contains('thanks') || cleanMsg.contains('thank you') || cleanMsg.contains('bye') || cleanMsg.contains('goodday')) {
        return const AiResponse(
          english: 'You are welcome! Thank you for your visit and have a wonderful day!',
          portuguese: 'De nada! Muito obrigado pela visita e tenha um ótimo dia!',
          nextHints: [
            'Thank you very much, goodbye!|Muito obrigado, tchau!',
            'See you later!|Até logo!',
            'Likewise, have a good day.|Igualmente, tenha um bom dia.'
          ],
        );
      }
      // Default cafe response
      return const AiResponse(
        english: 'Alright! I will bring that to you in a moment. Would you like anything else with your order?',
        portuguese: 'Anotado! Trago isso para você em um instante. Deseja algo mais com o seu pedido?',
        nextHints: [
          'No, that is all, thanks.|Não, é só isso, obrigado!',
          'Bring me the bill, please.|Traga-me a conta, por favor.',
          'Can I have some sugar?|Pode me trazer açúcar?'
        ],
      );
    } 
    
    else if (topicId == 'turismo') {
      if (cleanMsg.contains('subway') || cleanMsg.contains('metro') || cleanMsg.contains('station')) {
        return const AiResponse(
          english: 'The nearest subway station is just two blocks away. You can take the Red Line straight downtown. Do you have a transit card?',
          portuguese: 'A estação de metrô mais próxima fica a apenas dois quarteirões de distância. Você pode pegar a Linha Vermelha direto para o centro. Você tem um cartão de transporte?',
          nextHints: [
            'Yes, I have one.|Sim, eu tenho um.',
            'No, where can I buy one?|Não, onde posso comprar um?',
            'How much is a single ticket?|Quanto custa um bilhete único?'
          ],
        );
      }
      if (cleanMsg.contains('park') || cleanMsg.contains('central') || cleanMsg.contains('museum')) {
        return const AiResponse(
          english: 'Central Park is beautiful! You should rent a bike to explore it fully. Don\'t forget to visit the Bethesda Fountain. Have you been there yet?',
          portuguese: 'O Central Park é lindo! Você deveria alugar uma bicicleta para explorá-lo completamente. Não se esqueça de visitar a Bethesda Fountain. Você já esteve lá?',
          nextHints: [
            'No, not yet.|Não, ainda não.',
            'Yes, I went there yesterday.|Sim, eu fui lá ontem.',
            'What other attractions do you recommend?|Quais outras atrações você recomenda?'
          ],
        );
      }
      if (cleanMsg.contains('eat') || cleanMsg.contains('restaurant') || cleanMsg.contains('food') || cleanMsg.contains('hungry')) {
        return const AiResponse(
          english: 'For local food, you should try a slice of New York-style pizza or a traditional bagel nearby. Do you like pizza?',
          portuguese: 'Para comida local, você deveria experimentar uma fatia de pizza no estilo de Nova York ou um bagel tradicional por aqui. Você gosta de pizza?',
          nextHints: [
            'Yes, I love pizza!|Sim, eu adoro pizza!',
            'What other local dishes should I try?|Quais outros pratos locais devo provar?',
            'No, I prefer healthy food.|Não, eu prefiro comida saudável.'
          ],
        );
      }
      // Default turismo response
      return const AiResponse(
        english: 'This city has so much to offer! From museums to beautiful parks, you will love it. What else would you like to know?',
        portuguese: 'Esta cidade tem tanto a oferecer! De museus a belos parques, você vai adorar. O que mais você gostaria de saber?',
        nextHints: [
          'How does the public transit work?|Como funciona o transporte público?',
          'Are there any free museums?|Há algum museu gratuito?',
          'Thanks for these helpful tips!|Obrigado por estas dicas úteis!'
        ],
      );
    } 
    
    else if (topicId == 'casual') { // casual chat
      if (cleanMsg.contains('brasil') || cleanMsg.contains('brazil') || cleanMsg.contains('from')) {
        return const AiResponse(
          english: 'Ah, Brazil! What a beautiful and warm country. The weather there is so different from London! How long have you been studying English?',
          portuguese: 'Ah, o Brasil! Que país maravilhoso e caloroso. O clima lá é bem diferente de Londres! Há quanto tempo você estuda inglês?',
          nextHints: [
            'I have been studying for a few months.|Estudo há alguns meses.',
            'This is my first week learning.|Esta é minha primeira semana aprendendo.',
            'I am studying to travel abroad.|Estou estudando para viajar para o exterior.'
          ],
        );
      }
      if (cleanMsg.contains('well') || cleanMsg.contains('hello') || cleanMsg.contains('how')) {
        return const AiResponse(
          english: 'I am glad to hear that! I am doing very well too. What do you like to do in your free time? Any hobbies or sports?',
          portuguese: 'Fico feliz em ouvir isso! Eu também estou muito bem. O que você gosta de fazer no seu tempo livre? Algum hobby ou esporte?',
          nextHints: [
            'I enjoy listening to music and reading.|Gosto de ouvir música e ler.',
            'I play soccer with my friends.|Jogo futebol com meus amigos.',
            'I prefer watching movies and series.|Prefiro assistir a filmes e séries.'
          ],
        );
      }
      if (cleanMsg.contains('months') || cleanMsg.contains('years') || cleanMsg.contains('time')) {
        return const AiResponse(
          english: 'That is fantastic! Your pronunciation is already very good. Practicing a bit every day is the key. What is your goal with English?',
          portuguese: 'Isso é fantástico! Sua pronúncia já é muito boa. Praticar um pouco todo dia é a chave. Qual é o seu objetivo com o inglês?',
          nextHints: [
            'I want to study at a foreign university.|Quero estudar em uma universidade estrangeira.',
            'My dream is to travel to London.|Meu sonho é viajar para Londres.',
            'I just want to speak fluently.|Eu só quero falar fluentemente.'
          ],
        );
      }
      // Default casual response
      return const AiResponse(
        english: 'How interesting! Speaking a new language opens so many doors. Would you like to keep talking about this?',
        portuguese: 'Que interessante! Falar uma nova língua abre tantas portas. Gostaria de continuar falando sobre isso?',
        nextHints: [
          'Yes, let\'s keep talking, please.|Sim, vamos continuar conversando, por favor.',
          'I have another question.|Tenho outra pergunta.',
          'Thanks for the conversation!|Obrigado pela conversa!'
        ],
      );
    } else if (topicId == 'aeroporto') {
      if (cleanMsg.contains('tourism') || cleanMsg.contains('turismo') || cleanMsg.contains('turista') || cleanMsg.contains('visit')) {
        return const AiResponse(
          english: 'Great! Enjoy your trip. How long will you stay?',
          portuguese: 'Ótimo! Aproveite sua viagem. Quanto tempo você vai ficar?',
          nextHints: [
            'I will stay for ten days.|Vou ficar por dez dias.',
            'Just one week.|Apenas uma semana.',
            'About a month.|Cerca de um mês.'
          ],
        );
      }
      if (cleanMsg.contains('days') || cleanMsg.contains('weeks') || cleanMsg.contains('semana') || cleanMsg.contains('stay') || cleanMsg.contains('tiempo')) {
        return const AiResponse(
          english: 'Perfect. Where will you be staying during your visit?',
          portuguese: 'Perfeito. Onde você ficará hospedado durante sua visita?',
          nextHints: [
            'At a hotel downtown.|Em um hotel no centro.',
            'At my friend\'s house.|Na casa do meu amigo.',
            'I rented an apartment.|Aluguei um apartamento.'
          ],
        );
      }
      return const AiResponse(
        english: 'Alright. Please show me your documents and passport.',
        portuguese: 'Tudo bem. Por favor, mostre-me seus documentos e passaporte.',
        nextHints: [
          'Here is my passport.|Aqui está o meu passaporte.',
          'I am visiting as a tourist.|Estou visitando como turista.',
          'Okay, here you go.|Tudo bem, aqui está.'
        ],
      );
    } else if (topicId == 'hotel') {
      if (cleanMsg.contains('alex') || cleanMsg.contains('reservation') || cleanMsg.contains('reserva') || cleanMsg.contains('name') || cleanMsg.contains('nombre')) {
        return const AiResponse(
          english: 'I found your reservation for a double room. Could you please sign here?',
          portuguese: 'Encontrei sua reserva para um quarto duplo. Você poderia assinar aqui, por favor?',
          nextHints: [
            'Sure, here is my signature.|Claro, aqui está minha assinatura.',
            'Is breakfast included?|O café da manhã está incluso?',
            'Can I have two keys?|Pode me dar duas chaves?'
          ],
        );
      }
      if (cleanMsg.contains('breakfast') || cleanMsg.contains('desayuno') || cleanMsg.contains('servi') || cleanMsg.contains('sirve') || cleanMsg.contains('serve')) {
        return const AiResponse(
          english: 'Breakfast is served from 7 to 10 AM in the main dining room. Enjoy your meal!',
          portuguese: 'O café da manhã é servido das 7h às 10h no salão de jantar principal. Bom apetite!',
          nextHints: [
            'Thank you very much.|Muito obrigado.',
            'Is it on the first floor?|É no primeiro andar?',
            'What is the room number?|Qual é o número do quarto?'
          ],
        );
      }
      return const AiResponse(
        english: 'Here is your key. Your room is number 302 on the third floor. Let me know if you need help with your luggage.',
        portuguese: 'Aqui está sua chave. Seu quarto é o 302 no terceiro andar. Diga-me se precisar de ajuda com as malas.',
        nextHints: [
          'Thank you, I will go to my room now.|Obrigado, vou para o meu quarto agora.',
          'Where is the elevator?|Onde fica o elevador?',
          'Thanks for the help.|Obrigado pela ajuda.'
        ],
      );
    } else if (topicId == 'compras') {
      if (cleanMsg.contains('size') || cleanMsg.contains('medium') || cleanMsg.contains('tamanho') || cleanMsg.contains('talla')) {
        return const AiResponse(
          english: 'Yes, we have it in medium. Would you like to try it on in the fitting room?',
          portuguese: 'Sim, nós temos no tamanho M. Gostaria de provar no provador?',
          nextHints: [
            'Yes, where is the fitting room?|Sim, onde fica o provador?',
            'No, I will just take it.|Não, eu vou levar.',
            'Do you have it in blue too?|Você tem em azul também?'
          ],
        );
      }
      if (cleanMsg.contains('how much') || cleanMsg.contains('cost') || cleanMsg.contains('precio') || cleanMsg.contains('cuesta')) {
        return const AiResponse(
          english: 'This jacket is forty-five dollars. We have a ten percent discount today!',
          portuguese: 'Esta jaqueta custa quarenta e cinco dólares. Temos dez por cento de desconto hoje!',
          nextHints: [
            'Great, I will buy it.|Ótimo, vou comprar.',
            'Is it available in other colors?|Está disponível em outras cores?',
            'That is a bit expensive.|Isso é um pouco caro.'
          ],
        );
      }
      return const AiResponse(
        english: 'We also have sales on jeans and shoes today. Feel free to browse around.',
        portuguese: 'Também temos promoções de calças jeans e sapatos hoje. Sinta-se à vontade para dar uma olhada.',
        nextHints: [
          'Where are the jeans?|Onde ficam as calças jeans?',
          'Do you accept cash?|Vocês aceitam dinheiro?',
          'Okay, let me take a look.|Tudo bem, deixe-me dar uma olhada.'
        ],
      );
    } else {
      // Conversa livre fallback
      return const AiResponse(
        english: 'This is a great conversation. Keep speaking freely in English and I will correct your mistakes if needed.',
        portuguese: 'Esta é uma ótima conversa. Continue falando livremente em inglês e eu corrigirei seus erros se necessário.',
        nextHints: [
          'I want to continue talking.|Quero continuar conversando.',
          'How can I improve my English?|Como posso melhorar meu inglês?',
          'Thank you very much!|Muito obrigado!'
        ],
      );
    }
  }
}
