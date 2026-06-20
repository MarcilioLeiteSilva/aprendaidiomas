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

  // Backward-compat getter — defaults to Charlotte
  Map<String, String> get initialMessage => getInitialMessage('Charlotte');
}

class AiResponse {
  final String french;
  final String portuguese;
  final List<String> nextHints;

  const AiResponse({
    required this.french,
    required this.portuguese,
    required this.nextHints,
  });
}

class AiChatService {
  static final List<AiTopic> topics = [
    const AiTopic(
      id: 'cafe',
      title: 'Pedindo no Café Parisiense ☕',
      description: 'Pratique pedir croissants, cafés e interagir com o garçom em Paris.',
      icon: Icons.coffee_rounded,
      initialMessageTemplate: {
        'en': 'Bonjour ! Je m\'appelle {TUTOR}. Bienvenue au Café de Flore. Qu\'est-ce que je vous sers aujourd\'hui ?',
        'pt': 'Bom dia! Eu me chamo {TUTOR}. Bem-vindo ao Café de Flore. O que posso lhe servir hoje?'
      },
      initialHints: [
        'Un café et un croissant, s\'il vous plaît.|Um café e um croissant, por favor.',
        'Qu\'est-ce que vous recommandez ?|O que você recomenda?',
        'Je voudrais un chocolat chaud.|Eu gostaria de um chocolate quente.'
      ],
    ),
    const AiTopic(
      id: 'turismo',
      title: 'Explorando Paris e Turismo 🗼',
      description: 'Pergunte direções, recomendações do Louvre, Torre Eiffel e passeios.',
      icon: Icons.explore_rounded,
      initialMessageTemplate: {
        'en': 'Salut ! Je m\'appelle {TUTOR}, votre guide local. Quelle est votre prochaine destination à Paris ?',
        'pt': 'Olá! Eu me chamo {TUTOR}, seu guia local. Qual é o seu próximo destino em Paris?'
      },
      initialHints: [
        'Où se trouve la Tour Eiffel, s\'il vous plaît ?|Onde fica a Torre Eiffel, por favor?',
        'Je veux visiter le musée du Louvre.|Eu quero visitar o museu do Louvre.',
        'Quels sont les meilleurs endroits pour manger ?|Quais são os melhores lugares para comer?'
      ],
    ),
    const AiTopic(
      id: 'aeroporto',
      title: 'Imigração e Aeroporto ✈️',
      description: 'Pratique responder às perguntas do oficial de imigração, fazer check-in ou pedir ajuda com as malas.',
      icon: Icons.local_airport_rounded,
      initialMessageTemplate: {
        'en': 'Bonjour ! Bienvenue au contrôle de l\'immigration. Quel est le motif de votre visite ?',
        'pt': 'Olá! Bem-vindo ao controle de imigração. Qual é o motivo da sua visita?'
      },
      initialHints: [
        'Je viens pour le tourisme.|Venho a turismo.',
        'Je vais rester deux semaines.|Vou ficar por duas semanas.',
        'Je vais visiter des amis.|Vou visitar amigos.'
      ],
    ),
    const AiTopic(
      id: 'hotel',
      title: 'Check-in no Hotel 🏨',
      description: 'Pratique fazer check-in na recepção, confirmar sua reserva e pedir a senha do Wi-Fi.',
      icon: Icons.hotel_rounded,
      initialMessageTemplate: {
        'en': 'Bonjour ! Bienvenue dans notre hôtel. Avez-vous une réservation à votre nom ?',
        'pt': 'Olá! Bem-vindo ao nosso hotel. Você tem uma reserva em seu nome?'
      },
      initialHints: [
        'Oui, j\'ai une réservation au nom de Alex.|Sim, tenho uma reserva em nome de Alex.',
        'À quelle heure le petit-déjeuner est-il servi ?|A que horas o café da manhã é servido?',
        'Y a-t-il du Wi-Fi gratuit dans la chambre ?|Tem Wi-Fi gratuito no quarto?'
      ],
    ),
    const AiTopic(
      id: 'compras',
      title: 'Compras na Loja 🛍️',
      description: 'Pratique pedir tamanhos diferentes de roupas, perguntar os preços e efetuar o pagamento.',
      icon: Icons.shopping_bag_rounded,
      initialMessageTemplate: {
        'en': 'Bonjour ! Bienvenue. Dites-moi si vous avez besoin d\'aide pour trouver une taille ou une couleur. Vous cherchez quelque chose de particulier ?',
        'pt': 'Olá! Bem-vindo. Diga-me se precisar de ajuda para encontrar qualquer tamanho ou cor. Está procurando algo em especial?'
      },
      initialHints: [
        'Je regarde seulement, merci.|Só estou olhando, obrigado.',
        'Avez-vous cette chemise en taille M ?|Você tem essa camisa no tamanho M?',
        'Combien coûte cette veste ?|Quanto custa esta jaqueta?'
      ],
    ),
    const AiTopic(
      id: 'casual',
      title: 'Conversa Casual e Amizade 👋',
      description: 'Fale sobre seus hobbies, de onde você é e o que está achando da França.',
      icon: Icons.chat_rounded,
      initialMessageTemplate: {
        'en': 'Salut ! Enchanté. Je m\'appelle {TUTOR}. Comment vas-tu aujourd\'hui ?',
        'pt': 'Oi! Prazer em te conhecer. Eu me chamo {TUTOR}. Como você vai hoje?'
      },
      initialHints: [
        'Ça va très bien, merci ! Et toi ?|Tudo ótimo, obrigado! E você?',
        'Je suis un peu fatigué, mais ça va.|Estou um pouco cansado, mas tudo bem.',
        'Je m\'appelle Alex et je viens du Brésil.|Eu me chamo Alex e venho do Brasil.'
      ],
    ),
    const AiTopic(
      id: 'livre',
      title: 'Conversa Livre & Correções 💬',
      description: 'Converse livremente sobre qualquer assunto. O tutor corrigirá seus erros.',
      icon: Icons.psychology_rounded,
      initialMessageTemplate: {
        'en': 'Bonjour ! Je m\'appelle {TUTOR}. Parlons de ce que vous voulez aujourd\'hui ! N\'hésitez pas à faire des phrases, je suis là pour corriger vos erreurs.',
        'pt': 'Olá! Eu me chamo {TUTOR}. Vamos conversar sobre o que você quiser hoje! Sinta-se à vontade para formar frases, estou aqui para corrigir seus erros.'
      },
      initialHints: [
        'Aujourd\'hui je vais bien.|Hoje eu estou bem.',
        'Je voudrais parler de mes loisirs.|Eu gostaria de falar sobre meus hobbies.',
        'Pouvez-vous m\'aider à pratiquer ?|Você pode me ajudar a praticar?'
      ],
    ),
  ];

  // A simple rule-based local simulation that feels like real AI conversation
  static AiResponse generateResponse(String topicId, String userMessage) {
    final cleanMsg = userMessage.toLowerCase().trim();

    if (topicId == 'cafe') {
      if (cleanMsg.contains('recommande') || cleanMsg.contains('conseillez')) {
        return const AiResponse(
          french: 'Je vous recommande notre spécialité : un expresso serré avec un croissant chaud pur beurre. C\'est délicieux ! Vous voulez essayer ?',
          portuguese: 'Recomendo a nossa especialidade: um expresso curto com um croissant quente de pura manteiga. É delicioso! Quer experimentar?',
          nextHints: [
            'Oui, s\'il vous plaît, j\'en veux un.|Sim, por favor, eu quero um.',
            'Combien ça coûte ?|Quanto custa?',
            'Non merci, je préfère juste un thé.|Não obrigado, prefiro apenas um chá.'
          ],
        );
      }
      if (cleanMsg.contains('croissant') || cleanMsg.contains('pain') || cleanMsg.contains('manger')) {
        return const AiResponse(
          french: 'Très bien ! Un croissant bien croustillant. Souhaitez-vous une boisson chaude pour accompagner ? Un café au lait, peut-être ?',
          portuguese: 'Muito bem! Um croissant bem crocante. Gostaria de uma bebida quente para acompanhar? Um café com leite, talvez?',
          nextHints: [
            'Oui, un café au lait, s\'il vous plaît.|Sim, um café com leite, por favor.',
            'Je voudrais aussi un verre d\'eau.|Eu gostaria também de um copo de água.',
            'Non, c\'est tout, merci.|Não, é só isso, obrigado.'
          ],
        );
      }
      if (cleanMsg.contains('combien') || cleanMsg.contains('l\'addition') || cleanMsg.contains('payer')) {
        return const AiResponse(
          french: 'Ça fera six euros cinquante au total. Vous préférez régler par carte bancaire ou en espèces ?',
          portuguese: 'Ficará seis euros e cinquenta no total. Você prefere pagar com cartão de crédito ou em dinheiro?',
          nextHints: [
            'Je vais payer par carte.|Vou pagar com cartão.',
            'Voici dix euros. Gardez la monnaie.|Aqui estão dez euros. Fique com o troco.',
            'Est-ce que vous acceptez les chèques ?|Vocês aceitam cheques?'
          ],
        );
      }
      if (cleanMsg.contains('merci') || cleanMsg.contains('bonne journée') || cleanMsg.contains('revoir')) {
        return const AiResponse(
          french: 'Je vous en prie ! Merci de votre visite et passez une excellente journée à Paris !',
          portuguese: 'De nada! Obrigado pela sua visita e tenha um excelente dia em Paris!',
          nextHints: [
            'Merci beaucoup, au revoir !|Muito obrigado, tchau!',
            'À bientôt !|Até logo!',
            'Bonne journée à vous aussi.|Bom dia para você também.'
          ],
        );
      }
      // Default cafe response
      return const AiResponse(
        french: 'C\'est noté ! Je vous apporte cela dans un instant. Désirez-vous autre chose avec votre commande ?',
        portuguese: 'Anotado! Trago isso para você em um instante. Deseja algo mais com o seu pedido?',
        nextHints: [
          'Non, c\'est tout, merci !|Não, é só isso, obrigado!',
          'Apportez-moi l\'addition, s\'il vous plaît.|Traga-me a conta, por favor.',
          'Puis-je avoir du sucre ?|Pode me dar açúcar?'
        ],
      );
    } 
    
    else if (topicId == 'turismo') {
      if (cleanMsg.contains('eiffel') || cleanMsg.contains('tour')) {
        return const AiResponse(
          french: 'La Tour Eiffel est magnifique ! Elle se trouve sur le Champ de Mars. Vous pouvez y aller en métro via la station Bir-Hakeim. Voulez-vous y monter ?',
          portuguese: 'A Torre Eiffel é magnífica! Ela fica no Champ de Mars. Você pode ir de metrô pela estação Bir-Hakeim. Você deseja subir nela?',
          nextHints: [
            'Oui, je veux acheter un billet.|Sim, eu quero comprar um ingresso.',
            'Quel est le prix pour monter ?|Qual é o preço para subir?',
            'Je préfère la regarder d\'en bas.|Prefiro olhá-la de baixo.'
          ],
        );
      }
      if (cleanMsg.contains('louvre') || cleanMsg.contains('musée')) {
        return const AiResponse(
          french: 'Le musée du Louvre est immense ! N\'oubliez pas de réserver votre billet en ligne à l\'avance pour voir la Joconde. Avez-vous déjà votre ticket ?',
          portuguese: 'O museu do Louvre é imenso! Não se esqueça de reservar seu ingresso online com antecedência para ver a Mona Lisa. Você já tem seu ingresso?',
          nextHints: [
            'Non, où puis-je l\'acheter ?|Não, onde posso comprar?',
            'Oui, j\'ai déjà ma réservation.|Sim, já tenho minha reserva.',
            'Quels autres musées me conseillez-vous ?|Quais outros museus você me aconselha?'
          ],
        );
      }
      if (cleanMsg.contains('manger') || cleanMsg.contains('restaurant') || cleanMsg.contains('faim')) {
        return const AiResponse(
          french: 'Pour manger, évitez les restaurants trop près dos monuments. Essayez plutôt le quartier latin ou le Marais pour de la vraie cuisine française. Vous aimez le fromage ?',
          portuguese: 'Para comer, evite restaurantes muito perto dos monumentos. Em vez disso, experimente o Quartier Latin ou o Marais para culinária francesa de verdade. Você gosta de queijo?',
          nextHints: [
            'Oui, j\'adore le fromage français !|Sim, eu adoro queijo francês!',
            'Quels plats typiques dois-je goûter ?|Quais pratos típicos devo provar?',
            'Non, je préfère la cuisine italienne.|Não, prefiro a cozinha italiana.'
          ],
        );
      }
      // Default turismo response
      return const AiResponse(
        french: 'Paris a tant de choses à offrir ! Entre les jardins, les monuments et la Seine, vous allez adorer. Que voulez-vous savoir d\'autre sur la ville ?',
        portuguese: 'Paris tem tanto a oferecer! Entre os jardins, os monumentos e o rio Sena, você vai adorar. O que mais você gostaria de saber sobre a cidade?',
        nextHints: [
          'Comment fonctionne le métro ?|Como funciona o metrô?',
          'Y a-t-il des parcs gratuits à visiter ?|Há parques gratuitos para visitar?',
          'Merci pour ces conseils précieux.|Obrigado por esses conselhos preciosos.'
        ],
      );
    } 
    
    else if (topicId == 'casual') { // casual chat
      if (cleanMsg.contains('brésil') || cleanMsg.contains('bresil') || cleanMsg.contains('venez')) {
        return const AiResponse(
          french: 'Ah, le Brésil ! Quel pays magnifique et chaleureux. Le climat y est bien différent de Paris ! Depuis combien de temps apprenez-vous le français ?',
          portuguese: 'Ah, o Brasil! Que país maravilhoso e acolhedor. O clima lá é bem diferente de Paris! Há quanto tempo você estuda francês?',
          nextHints: [
            'J\'apprends le français depuis quelques mois.|Estudo francês há alguns meses.',
            'C\'est ma première semaine d\'apprentissage.|É a minha primeira semana de aprendizado.',
            'J\'apprends pour voyager en France.|Estou aprendendo para viajar para a França.'
          ],
        );
      }
      if (cleanMsg.contains('bien') || cleanMsg.contains('va') || cleanMsg.contains('salut')) {
        return const AiResponse(
          french: 'Ravi de l\'entendre ! Moi aussi je vais très bien. Qu\'aimez-vous faire pendant votre temps libre ? Vous faites du sport ou de la musique ?',
          portuguese: 'Prazer em ouvir isso! Eu também vou muito bem. O que você gosta de fazer no tempo livre? Pratica esportes ou música?',
          nextHints: [
            'J\'aime écouter de la musique et lire.|Gosto de ouvir música e ler.',
            'Je joue au football avec des amis.|Jogo futebol com amigos.',
            'Je préfère regarder des films.|Prefiro assistir a filmes.'
          ],
        );
      }
      if (cleanMsg.contains('mois') || cleanMsg.contains('ans') || cleanMsg.contains('temps')) {
        return const AiResponse(
          french: 'C\'est fantastique ! Votre prononciation est déjà très bonne. Pratiquer un peu chaque jour est le secret de la réussite. Quel est votre plus grand rêve en France ?',
          portuguese: 'Isso é fantástico! Sua pronúncia já é muito boa. Praticar um pouco todo dia é o segredo do sucesso. Qual é o seu maior sonho na França?',
          nextHints: [
            'Je veux étudier dans une université française.|Quero estudar em uma universidade francesa.',
            'Mon rêve est de visiter Paris et la Côte d\'Azur.|Meu sonho é visitar Paris e a Côte d\'Azur.',
            'Je veux juste parler couramment.|Eu só quero falar fluentemente.'
          ],
        );
      }
      // Default casual response
      return const AiResponse(
        french: 'C\'est très intéressant ! Parler une nouvelle langue ouvre tellement de portes. Aimeriez-vous que l\'on continue de discuter de cela ?',
        portuguese: 'Isso é muito interessante! Falar uma nova língua abre tantas portas. Gostaria de continuar conversando sobre isso?',
        nextHints: [
          'Oui, continuons à parler, s\'il vous plaît.|Sim, vamos continuar conversando, por favor.',
          'J\'ai une autre question.|Tenho outra pergunta.',
          'Merci pour la conversation !|Obrigado pela conversa!'
        ],
      );
    } else if (topicId == 'aeroporto') {
      if (cleanMsg.contains('tourisme') || cleanMsg.contains('touriste') || cleanMsg.contains('visit')) {
        return const AiResponse(
          french: 'Excellent ! Profitez de votre voyage. Combien de temps allez-vous rester ?',
          portuguese: 'Excelente! Aproveite sua viagem. Quanto tempo você vai ficar?',
          nextHints: [
            'Je vais rester dix jours.|Vou ficar dez dias.',
            'Seulement une semaine.|Apenas uma semana.',
            'Environ un mois.|Cerca de un mês.'
          ],
        );
      }
      if (cleanMsg.contains('jours') || cleanMsg.contains('semaine') || cleanMsg.contains('reste') || cleanMsg.contains('temps')) {
        return const AiResponse(
          french: 'Parfait. Où allez-vous loger pendant votre visite ?',
          portuguese: 'Perfeito. Onde você ficará hospedado durante sua visita?',
          nextHints: [
            'Dans un hôtel au centre-ville.|Em um hotel no centro.',
            'Chez un ami.|Na casa de um amigo.',
            'J\'ai loué un appartement.|Aluguei um apartamento.'
          ],
        );
      }
      return const AiResponse(
        french: 'D\'accord. S\'il vous plaît, montrez-moi vos documents et votre passeport.',
        portuguese: 'Tudo bem. Por favor, mostre-me seus documentos e passaporte.',
        nextHints: [
          'Voici mon passeport.|Aqui está o meu passaporte.',
          'Je viens pour le tourisme.|Venho a turismo.',
          'D\'accord, voici.|Tudo bem, aqui está.'
        ],
      );
    } else if (topicId == 'hotel') {
      if (cleanMsg.contains('alex') || cleanMsg.contains('reservation') || cleanMsg.contains('reserva') || cleanMsg.contains('nom') || cleanMsg.contains('name')) {
        return const AiResponse(
          french: 'J\'ai trouvé votre réservation pour une chambre double. Pourriez-vous signer ici, s\'il vous plaît ?',
          portuguese: 'Encontrei sua reserva para um quarto duplo. Você poderia assinar aqui, por favor?',
          nextHints: [
            'Bien sûr, voici ma signature.|Claro, aqui está minha assinatura.',
            'Le petit-déjeuner est-il inclus ?|O café da manhã está incluso?',
            'Puis-je avoir deux clés ?|Pode me dar duas chaves?'
          ],
        );
      }
      if (cleanMsg.contains('petit-déjeuner') || cleanMsg.contains('petit-dejeuner') || cleanMsg.contains('servi') || cleanMsg.contains('serve') || cleanMsg.contains('dejeuner')) {
        return const AiResponse(
          french: 'Le petit-déjeuner est servi de 7h à 10h dans la salle à manger principale. Bon appétit !',
          portuguese: 'O café da manhã é servido das 7h às 10h no salão de jantar principal. Bom apetite!',
          nextHints: [
            'Merci beaucoup.|Muito obrigado.',
            'Est-ce au premier étage?|É no primeiro andar?',
            'Quel est le numéro de chambre?|Qual é o número do quarto?'
          ],
        );
      }
      return const AiResponse(
        french: 'Voici votre clé. Votre chambre est la 302 au troisième étage. Dites-moi si vous avez besoin d\'aide pour vos bagages.',
        portuguese: 'Aqui está sua chave. Seu quarto é o 302 no terceiro andar. Diga-me se precisar de ajuda com as malas.',
        nextHints: [
          'Merci, je vais dans ma chambre maintenant.|Obrigado, vou para o meu quarto agora.',
          'Où se trouve l\'ascenseur ?|Onde fica o elevador?',
          'Merci pour l\'aide.|Obrigado pela ajuda.'
        ],
      );
    } else if (topicId == 'compras') {
      if (cleanMsg.contains('taille') || cleanMsg.contains('tamanho') || cleanMsg.contains('m') || cleanMsg.contains('medium')) {
        return const AiResponse(
          french: 'Oui, nous l\'avons en taille M. Voudriez-vous l\'essayer dans la cabine d\'essayage ?',
          portuguese: 'Sim, nós temos no tamanho M. Gostaria de provar no provador?',
          nextHints: [
            'Oui, où est la cabine d\'essayage ?|Sim, onde fica o provador?',
            'Non, je vais juste la prendre.|Não, vou apenas levar.',
            'L\'avez-vous en bleu aussi ?|Você tem em azul também?'
          ],
        );
      }
      if (cleanMsg.contains('combien') || cleanMsg.contains('prix') || cleanMsg.contains('cout') || cleanMsg.contains('coûte')) {
        return const AiResponse(
          french: 'Cette veste coûte quarante-cinq euros. Nous avons une réduction de dix pour cent aujourd\'hui !',
          portuguese: 'Esta jaqueta custa quarenta e cinco euros. Temos dez por cento de desconto hoje!',
          nextHints: [
            'Génial, je vais l\'acheter.|Ótimo, vou comprar.',
            'Est-elle disponible en d\'autres couleurs ?|Está disponível em outras cores?',
            'C\'est un peu cher.|É um pouco caro.'
          ],
        );
      }
      return const AiResponse(
        french: 'Nous avons également des soldes sur les jeans et les chaussures aujourd\'hui. N\'hésitez pas à regarder autour de vous.',
        portuguese: 'Também temos promoções de calças jeans e sapatos hoje. Sinta-se à vontade para dar uma olhada.',
        nextHints: [
          'Où sont les jeans ?|Onde ficam as calças jeans?',
          'Acceptez-vous les espèces ?|Vocês aceitam dinheiro?',
          'D\'accord, laissez-moi jeter un coup d\'œil.|Tudo bem, deixe-me dar uma olhada.'
        ],
      );
    } else {
      // Conversa livre fallback
      return const AiResponse(
        french: 'C\'est une excellente conversation. Continuez à parler librement en français et je corrigerai vos erreurs si nécessaire.',
        portuguese: 'Essa é uma ótima conversa. Continue falando livremente em francês e eu corrigirei seus erros se necessário.',
        nextHints: [
          'Je veux continuer à parler.|Quero continuar conversando.',
          'Comment puis-je m\'améliorer ?|Como posso melhorar?',
          'Merci beaucoup !|Muito obrigado!'
        ],
      );
    }
  }
}
