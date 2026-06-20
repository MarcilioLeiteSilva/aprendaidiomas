import 'package:flutter/material.dart';

enum SpeakingLevel { basic, intermediate, advanced, native }

class SpeakingMessage {
  final String en; // Keep variable name to avoid refactoring models/UI
  final String pt;
  final bool isBot;

  const SpeakingMessage({
    required this.en,
    required this.pt,
    required this.isBot,
  });
}

class SpeakingScenario {
  final int id;
  final String title;
  final String description;
  final SpeakingLevel level;
  final IconData icon;
  final List<SpeakingMessage> messages;

  const SpeakingScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.icon,
    required this.messages,
  });
}

final List<SpeakingScenario> speakingScenarios = [
  // ==========================================
  // BASIC LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 1,
    title: "No Café",
    description: "Aprenda a pedir seu café favorito e um doce em francês.",
    level: SpeakingLevel.basic,
    icon: Icons.coffee_rounded,
    messages: [
      SpeakingMessage(en: "Bonjour ! Bienvenue dans notre café. Que puis-je vous servir aujourd'hui ?", pt: "Olá! Bem-vindo ao nosso café. O que posso te servir hoje?", isBot: true),
      SpeakingMessage(en: "Je voudrais un cappuccino chaud et un croissant au chocolat, s'il vous plaît.", pt: "Eu gostaria de um cappuccino quente e um croissant de chocolate, por favor.", isBot: false),
      SpeakingMessage(en: "Bien sûr ! Quelle taille de cappuccino désirez-vous ? Petit, moyen ou grand ?", pt: "Claro! Qual tamanho de cappuccino você gostaria? Pequeno, médio ou grande?", isBot: true),
      SpeakingMessage(en: "Un cappuccino moyen est parfait, merci.", pt: "Um cappuccino médio é perfeito, obrigado.", isBot: false),
      SpeakingMessage(en: "Super ! Ça fera six dollars. Ce sera en espèces ou par carte ?", pt: "Ótimo! Fica em seis dólares. Será em dinheiro ou cartão?", isBot: true),
      SpeakingMessage(en: "Je vais payer par carte. S'il vous plaît.", pt: "Vou pagar com cartão. Aqui está.", isBot: false),
      SpeakingMessage(en: "Merci. Votre commande sera prête au comptoir dans une minute.", pt: "Obrigado. Seu pedido estará pronto no balcão em um minuto.", isBot: true),
    ],
  ),

  // ==========================================
  // INTERMEDIATE LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 2,
    title: "Check-in no Hôtel",
    description: "Pratique o check-in em um hotel e pergunte sobre as comodidades.",
    level: SpeakingLevel.intermediate,
    icon: Icons.hotel_rounded,
    messages: [
      SpeakingMessage(en: "Bonjour. Bienvenue au Grand Plaza Hôtel. Avez-vous une réservation ?", pt: "Boa tarde. Bem-vindo ao Grand Plaza Hotel. Você tem uma reserva?", isBot: true),
      SpeakingMessage(en: "Oui, j'ai une réservation au nom de John Smith.", pt: "Sim, eu tenho uma reserva sob o nome de John Smith.", isBot: false),
      SpeakingMessage(en: "Ah oui, Monsieur Smith. Une chambre double de luxe pour trois nuits. Est-ce correct ?", pt: "Ah, sim, Sr. Smith. Um quarto duplo de luxo por três noites. Está correto?", isBot: true),
      SpeakingMessage(en: "C'est exact. Le petit-déjeuner est-il inclus dans mon séjour ?", pt: "Está correto. O café da manhã está incluso na minha estadia?", isBot: false),
      SpeakingMessage(en: "Oui, le petit-déjeuner est servi de 7h à 10h dans le restaurant principal. Voici vos clés.", pt: "Sim, o café da manhã é servido das sete às dez no restaurante principal. Aqui estão suas chaves.", isBot: true),
      SpeakingMessage(en: "Parfait. Où se trouve la salle de sport et ai-je besoin d'un code ?", pt: "Perfeito. Onde a academia fica localizada e eu preciso de um código?", isBot: false),
      SpeakingMessage(en: "La salle de sport est au deuxième étage et vous pouvez y accéder avec la clé de votre chambre.", pt: "La academia fica no segundo andar e você pode acessá-la com a chave do seu quarto.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 3,
    title: "Entrevista de Emprego",
    description: "Discuta suas qualidades e experiências profissionais em francês.",
    level: SpeakingLevel.advanced,
    icon: Icons.work_rounded,
    messages: [
      SpeakingMessage(en: "Merci d'être venu aujourd'hui. Pour commencer, pouvez-vous me parler un peu de votre parcours ?", pt: "Obrigado por vir hoje. Para começar, você poderia me contar um pouco sobre o seu histórico?", isBot: true),
      SpeakingMessage(en: "Je travaille comme développeur de logiciels depuis cinq ans, spécialisé dans les applications mobiles.", pt: "Trabalho como desenvolvedor de software há cinco anos, me especializando em aplicativos móveis.", isBot: false),
      SpeakingMessage(en: "C'est impressionnant. Pouvez-vous décrire un projet difficile que vous avez géré avec succès ?", pt: "Isso parece impressionante. Você pode descrever um projeto desafiador que gerenciou com sucesso?", isBot: true),
      SpeakingMessage(en: "J'ai récemment dirigé une équipe pour refondre notre application principale, réduisant les temps de chargement de 40%.", pt: "Recentemente liderei uma equipe para redesenhar nosso aplicativo principal, reduzindo o tempo de carregamento em quarenta por cento.", isBot: false),
      SpeakingMessage(en: "Excellent. Pourquoi pensez-vous être la bonne personne pour ce poste ?", pt: "Excelente. Por que você acredita que é a pessoa certa para esta posição em nossa empresa?", isBot: true),
      SpeakingMessage(en: "J'apporte une solide éthique de travail, une expertise technique et une passion pour la création de produits simples.", pt: "Trago uma forte ética de trabalho, experiência técnica e paixão por criar produtos fáceis de usar.", isBot: false),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 4,
    title: "Pedindo um Favor",
    description: "Use expressões naturais para pedir um grande favor a um amigo em francês.",
    level: SpeakingLevel.native,
    icon: Icons.handshake_rounded,
    messages: [
      SpeakingMessage(en: "Dis-moi, tu as une seconde ? J'ai vraiment besoin de te parler de quelque chose.", pt: "Ei cara, você tem um segundo? Eu realmente preciso falar uma coisa com você.", isBot: true),
      SpeakingMessage(en: "Bien sûr, qu'est-ce qu'il y a ? Tu as l'air un peu stressé, tout va bien ?", pt: "Claro, o que houve? Você parece um pouco estressado, está tudo bem?", isBot: false),
      SpeakingMessage(en: "Pour être honnête, je suis dans une situation difficile. Ma voiture est en panne et je dois emmener ma sœur à l'aéroport.", pt: "Para falar a verdade, estou em apuros. Meu carro quebrou e preciso levar minha irmã ao aeroporto.", isBot: true),
      SpeakingMessage(en: "Ne t'inquiète pas ! Je peux l'emmener. On se connaît depuis longtemps, donc ce n'est pas un problème.", pt: "Não se preocupe! Eu posso levá-la. Nós somos velhos amigos, então realmente não é grande coisa.", isBot: false),
      SpeakingMessage(en: "Oh merci, tu me sauves la vie ! Je te revaudrai ça, vraiment.", pt: "Cara, você salvou minha vida! Te devo uma grande por causa disso, sério.", isBot: true),
      SpeakingMessage(en: "Ne t'en fais pas pour ça. Rends-moi simplement service la prochaine fois que je serai en difficulté.", pt: "Nem esquenta com isso. Apenas retribua o favor na próxima vez que eu estiver em apuros.", isBot: false),
    ],
  ),

  // ==========================================
  // BASIC LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 5,
    title: "Pedindo Direções",
    description: "Aprenda a pedir e entender direções simples na rua em francês.",
    level: SpeakingLevel.basic,
    icon: Icons.map_rounded,
    messages: [
      SpeakingMessage(en: "Excusez-moi, savez-vous où se trouve la station de métro la plus proche ?", pt: "Com licença, você sabe onde fica a estação de metrô mais próxima?", isBot: true),
      SpeakingMessage(en: "Oui, allez tout droit pendant deux blocs puis tournez à gauche.", pt: "Sim, vá reto por duas quadras e depois vire à esquerda.", isBot: false),
      SpeakingMessage(en: "Merci ! Est-ce que c'est loin d'ici ou puis-je y aller à pied ?", pt: "Obrigado! Fica longe daqui ou eu posso ir andando?", isBot: true),
      SpeakingMessage(en: "C'est très proche. Il ne faut que cinq minutes à pied pour y aller.", pt: "É muito perto. Leva apenas os cinco minutos para ir andando até lá.", isBot: false),
      SpeakingMessage(en: "Parfait, merci beaucoup pour votre aide ! Bonne journée !", pt: "Perfeito, muito obrigado pela sua ajuda! Tenha um ótimo dia!", isBot: true),
      SpeakingMessage(en: "De rien. Bon voyage !", pt: "De nada. Tenha uma boa viagem!", isBot: false),
    ],
  ),

  // ==========================================
  // INTERMEDIATE LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 6,
    title: "Consulta Médica",
    description: "Descreva seus sintomas a um médico e receba conselhos de saúde.",
    level: SpeakingLevel.intermediate,
    icon: Icons.local_hospital_rounded,
    messages: [
      SpeakingMessage(en: "Bonjour. Quel semble être le problème aujourd'hui ?", pt: "Bom dia. Qual parece ser o problema hoje?", isBot: true),
      SpeakingMessage(en: "J'ai un gros mal de tête et mal à la gorge depuis hier.", pt: "Estou com uma forte dor de cabeça e dor de garganta desde ontem.", isBot: false),
      SpeakingMessage(en: "Avez-vous également de la fièvre ou de la toux ?", pt: "Você também tem febre ou tosse?", isBot: true),
      SpeakingMessage(en: "I'ai eu une légère fièvre hier soir, mais pas de toux.", pt: "Tive uma febre leve ontem à noite, mas sem tosse.", isBot: false),
      SpeakingMessage(en: "Je vois. Je vais vous prescrire des médicaments. Reposez-vous et buvez beaucoup d'eau.", pt: "Entendo. Vou receitar alguns remédios. Descanse e beba bastante água.", isBot: true),
      SpeakingMessage(en: "Merci, docteur. À quelle fréquence dois-je prendre le médicament ?", pt: "Obrigado, doutor. Com que frequência devo tomar o remédio?", isBot: false),
      SpeakingMessage(en: "Prenez un comprimé toutes les huit heures après les repas.", pt: "Tome um comprimido a cada oito horas após as refeições.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 7,
    title: "Negociando o Aluguel",
    description: "Discuta termos de contrato, preços e taxas de um apartamento.",
    level: SpeakingLevel.advanced,
    icon: Icons.real_estate_agent_rounded,
    messages: [
      SpeakingMessage(en: "Bonjour, merci de visiter l'appartement. Que pensez-vous du contrat de location ?", pt: "Olá, obrigado por visitar o apartamento. O que você acha do contrato de aluguel?", isBot: true),
      SpeakingMessage(en: "L'appartement est superbe, mais le loyer mensuel dépasse un peu mon budget.", pt: "O apartamento é ótimo, mas o aluguel mensal está um pouco acima do meu orçamento.", isBot: false),
      SpeakingMessage(en: "Je comprends, mais cela comprend l'eau et un parking privé. À quel prix pensiez-vous ?", pt: "Eu entendo, mas inclui água e uma vaga de estacionamento privativa. Que preço você tinha em mente?", isBot: true),
      SpeakingMessage(en: "Considéreriez-vous une réduction de 5% si je signe un contrat de deux ans ?", pt: "Você consideraria um desconto de cinco por cento se eu assinar um contrato de dois anos?", isBot: false),
      SpeakingMessage(en: "Cela semble raisonnable. Si vous signez pour deux ans, je peux baisser le prix.", pt: "Isso parece razoável. Se você assinar por dois anos, posso baixar o preço.", isBot: true),
      SpeakingMessage(en: "Excellent. Pouvons-nous mettre à jour le contrat et le signer lundi prochain ?", pt: "Excelente. Podemos atualizar o contrato e assiná-lo na próxima segunda-feira?", isBot: false),
      SpeakingMessage(en: "Oui, je vais préparer le bail révisé et vous l'envoyer par e-mail demain.", pt: "Sim, vou preparar o contrato revisado e enviar por e-mail para você amanhã.", isBot: true),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 8,
    title: "Colocando o Papo em Dia",
    description: "Use expressões informais para conversar sobre uma viagem de fim de semana.",
    level: SpeakingLevel.native,
    icon: Icons.people_rounded,
    messages: [
      SpeakingMessage(en: "Ça fait longtemps qu'on ne s'est pas vus ! Tu dois tout me raconter sur ton week-end.", pt: "Há quanto tempo! Você tem que me contar tudo sobre a sua viagem de fim de semana.", isBot: true),
      SpeakingMessage(en: "Ah, c'était génial ! On est allés à la plage et on s'est détendus tout le temps.", pt: "Ah, foi sensacional! Nós fomos para a praia e apenas relaxamos o tempo todo.", isBot: false),
      SpeakingMessage(en: "Pas possible ! Je suis trop jaloux. Tu as testé le nouveau resto de fruits de mer près de la jetée ?", pt: "Não brinca! Que inveja. Vocês foram àquele novo restaurante de frutos do mar perto do píer?", isBot: true),
      SpeakingMessage(en: "Oui ! C'était un peu cher, mais la nourriture était incroyable.", pt: "Sim, nós fomos! Foi um pouco caro, mas a comida estava fora desse mundo.", isBot: false),
      SpeakingMessage(en: "Super. Ça fait un moment que je veux y aller. On devrait se voir bientôt et planifier ça ensemble.", pt: "Incrível. Estou querendo ir lá faz tempo. Vamos nos encontrar logo e planejar uma juntos.", isBot: true),
      SpeakingMessage(en: "Carrément ! On s'appelle la semana prochaine pour régler les détails.", pt: "Com certeza! Vamos nos falar na próxima semana e acertar os detalhes.", isBot: false),
    ],
  ),

  // ==========================================
  // BASIC LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 9,
    title: "Comprando passagem de Trem",
    description: "Aprenda a perguntar por tarifas e horários na estação de trem.",
    level: SpeakingLevel.basic,
    icon: Icons.train_rounded,
    messages: [
      SpeakingMessage(en: "Bonjour ! Comment puis-je vous aider aujourd'hui ?", pt: "Olá! Como posso te ajudar hoje?", isBot: true),
      SpeakingMessage(en: "Je voudrais un billet pour Londres, s'il vous plaît.", pt: "Eu gostaria de uma passagem para Londres, por favor.", isBot: false),
      SpeakingMessage(en: "Aller simple ou aller-retour ? Et pour quelle heure ?", pt: "Passagem de ida ou ida e volta? E para qual horário?", isBot: true),
      SpeakingMessage(en: "Un aller simple pour le prochain train, s'il vous plaît.", pt: "Uma passagem de ida para o próximo trem, por favor.", isBot: false),
      SpeakingMessage(en: "Le prochain train part à dix heures. Ça fera quinze dollars.", pt: "O próximo trem sai às dez. Fica em quinze dólares.", isBot: true),
      SpeakingMessage(en: "Voici l'argent. C'est sur quel quai ?", pt: "Aqui está o dinheiro. Qual é a plataforma?", isBot: false),
      SpeakingMessage(en: "C'est le quai numéro quatre. Bon voyage !", pt: "É a plataforma quatro. Tenha uma boa viagem!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 10,
    title: "Apresentando-se",
    description: "Pratique falar seu nome, de onde você é e sua idade.",
    level: SpeakingLevel.basic,
    icon: Icons.person_pin_rounded,
    messages: [
      SpeakingMessage(en: "Salut ! Moi c'est Sarah. Quel est ton nom ?", pt: "Olá! Eu sou a Sarah. Qual é o seu nome?", isBot: true),
      SpeakingMessage(en: "Bonjour Sarah ! Je m'appelle Lucas. Ravi de te rencontrer.", pt: "Olá Sarah! Meu nome é Lucas. Prazer em te conhecer.", isBot: false),
      SpeakingMessage(en: "Ravie de te rencontrer aussi, Lucas. Tu viens d'où ?", pt: "Prazer em te conhecer também, Lucas. De onde você é?", isBot: true),
      SpeakingMessage(en: "Je viens du Brésil, mais j'habite à New York maintenant.", pt: "Eu sou do Brasil, mas moro em Nova York agora.", isBot: false),
      SpeakingMessage(en: "Oh, c'est génial ! Quel âge as-tu, si je peux demander ?", pt: "Ah, isso é ótimo! Quantos anos você tem, se me permite perguntar?", isBot: true),
      SpeakingMessage(en: "J'ai vingt-cinq ans. Et toi ?", pt: "Eu tenho vinte e de cinco anos. E você?", isBot: false),
      SpeakingMessage(en: "J'ai vingt-huit ans. J'espère que tu passeras un bon moment ici !", pt: "Eu tenho vinte e oito. Espero que você aproveite seu tempo aqui!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 11,
    title: "No Supermercado",
    description: "Aprenda a pedir preços e encontrar itens na mercearia.",
    level: SpeakingLevel.basic,
    icon: Icons.shopping_cart_rounded,
    messages: [
      SpeakingMessage(en: "Excusez-moi, monsieur. Avez-vous besoin d'aide pour trouver quelque chose ?", pt: "Com licença, senhor. Precisa de ajuda para encontrar algo?", isBot: true),
      SpeakingMessage(en: "Oui, s'il vous plaît. Où puis-je trouver le lait frais ?", pt: "Sim, por favor. Onde posso encontrar o leite fresco?", isBot: false),
      SpeakingMessage(en: "C'est au rayon trois, à côté du fromage.", pt: "Fica no corredor três, ao lado do queijo.", isBot: true),
      SpeakingMessage(en: "Merci. Et combien coûte ce sac de pommes ?", pt: "Obrigado. E quanto custa um saco de maçãs?", isBot: false),
      SpeakingMessage(en: "Ils sont à quatre dollars le kilo aujourd'hui.", pt: "Estão quatro dólares o quilo hoje.", isBot: true),
      SpeakingMessage(en: "Super, je vais en prendre un kilo. Où est la caisse ?", pt: "Ótimo, vou levar um quilo. Onde fica o caixa?", isBot: false),
      SpeakingMessage(en: "Les caisses sont à l'entrée du magasin.", pt: "Os caixas ficam na frente da loja.", isBot: true),
    ],
  ),

  // ==========================================
  // INTERMEDIATE LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 12,
    title: "Pedindo Delivery de Comida",
    description: "Ligue para um restaurante para pedir comida e pergunte sobre o tempo de entrega.",
    level: SpeakingLevel.intermediate,
    icon: Icons.delivery_dining_rounded,
    messages: [
      SpeakingMessage(en: "Merci d'avoir appelé Pizza Palace. Voulez-vous passer une commande ?", pt: "Obrigado por ligar para o Pizza Palace. Gostaria de fazer um pedido?", isBot: true),
      SpeakingMessage(en: "Oui, je voudrais une grande pizza au pepperoni et une bouteille de soda.", pt: "Sim, eu gostaria de uma pizza grande de pepperoni e uma garrafa de refrigerante.", isBot: false),
      SpeakingMessage(en: "Bien sûr. Est-ce que c'est à emporter ou pour une livraison à domicile ?", pt: "Claro. É para retirar ou entrega na sua casa?", isBot: true),
      SpeakingMessage(en: "C'est pour une livraison au douze, rue principale.", pt: "É para entrega na rua principal, casa número doze.", isBot: false),
      SpeakingMessage(en: "Parfait. Le total est de vingt-cinq dollars. Comment allez-vous payer ?", pt: "Perfeito. O total fica em vinte e cinco dólares. Como irá pagar?", isBot: true),
      SpeakingMessage(en: "Je paierai en espèces à la livraison. Combien de temps cela prendra-t-il ?", pt: "Vou pagar com dinheiro na entrega. Quanto tempo vai levar?", isBot: false),
      SpeakingMessage(en: "Cela devrait arriver dans environ trente à quarante minutes. Merci !", pt: "Deve chegar em cerca de trinta a quarenta minutos. Obrigado!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 13,
    title: "Relatando um Item Perdido",
    description: "Descreva uma bolsa perdida para a segurança do aeroporto ou equipe do hotel.",
    level: SpeakingLevel.intermediate,
    icon: Icons.find_in_page_rounded,
    messages: [
      SpeakingMessage(en: "Bureau des objets trouvés. Comment puis-je vous aider aujourd'hui ?", pt: "Departamento de Achados e Perdidos. Como posso te ajudar hoje?", isBot: true),
      SpeakingMessage(en: "Je pense avoir laissé mon sac à dos sur le vol en provenance de Miami.", pt: "Acho que deixei minha mochila no voo vindo de Miami.", isBot: false),
      SpeakingMessage(en: "Pouvez-vous décrire le sac à dos et me donner votre numéro de vol ?", pt: "Você pode descrever a mochila e me dizer o número do seu voo?", isBot: true),
      SpeakingMessage(en: "C'est un sac à dos en cuir noir avec deux grandes poches latérales.", pt: "É uma mochila de couro preta com dois bolsos laterais grandes.", isBot: false),
      SpeakingMessage(en: "Et y avait-il une étiquette de nom ou une identification dessus ?", pt: "E ela tinha alguma etiqueta de nome ou identificação?", isBot: true),
      SpeakingMessage(en: "Oui, il y a une petite étiquette bleue avec mon nom, John Doe.", pt: "Sim, há uma pequena etiqueta azul com meu nome, John Doe.", isBot: false),
      SpeakingMessage(en: "D'accord. Nous allons vérifier la cabine et nous vous contacterons si nous le trouvons.", pt: "Tudo bem. Vamos verificar a cabine e entraremos em contato se a encontrarmos.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 14,
    title: "Pedindo Recomendações",
    description: "Pergunte a um morador local por recomendações turísticas e lugares para jantar.",
    level: SpeakingLevel.intermediate,
    icon: Icons.recommend_rounded,
    messages: [
      SpeakingMessage(en: "Bienvenue dans notre centre d'accueil ! Cherchez-vous quelque chose de particulier ?", pt: "Bem-vindo ao nosso centro de visitantes! Está procurando por algo específico?", isBot: true),
      SpeakingMessage(en: "J'ai deux jours ici. Quels sont les meilleurs endroits à visiter ?", pt: "Tenho dois dias aqui. Quais são os melhores pontos turísticos para ver?", isBot: false),
      SpeakingMessage(en: "Vous devriez visiter le château historique et faire une promenade en bateau.", pt: "Você deve visitar o castelo histórico e fazer um passeio de barco.", isBot: true),
      SpeakingMessage(en: "Ça a l'air amusant. Connaissez-vous un bon restaurant local à proximité ?", pt: "Isso parece divertido. Você conhece um bom restaurante local por perto?", isBot: false),
      SpeakingMessage(en: "Le Seafood Grill près du port sert d'excellents plats locaux.", pt: "O Seafood Grill perto do porto serve excelentes pratos locais.", isBot: true),
      SpeakingMessage(en: "Dois-je réserver pour dîner là-bas ?", pt: "Eu preciso fazer uma reserva para o jantar lá?", isBot: false),
      SpeakingMessage(en: "C'est très fréquenté le week-end, je vous conseille donc d'appeler à l'avance.", pt: "Fica movimentado nos fins de semana, então recomendo ligar com antecedência.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 15,
    title: "Reunião de Negócios",
    description: "Discuta prazos de projetos e funções de equipe em um ambiente profissional.",
    level: SpeakingLevel.advanced,
    icon: Icons.co_present_rounded,
    messages: [
      SpeakingMessage(en: "Merci de votre participation. Discutons du calendrier du projet pour le trimestre prochain.", pt: "Obrigado por participar. Vamos discutir o cronograma do projeto para o próximo trimestre.", isBot: true),
      SpeakingMessage(en: "Nous devons ajuster la date limite car la conception a pris du retard.", pt: "Precisamos ajustar o prazo porque o design está atrasado.", isBot: false),
      SpeakingMessage(en: "De combien de temps supplémentaire l'équipe de conception a-t-elle besoin pour finaliser ?", pt: "De quanto tempo extra a equipe de design precisa para finalizar o layout?", isBot: true),
      SpeakingMessage(en: "Ils ont demandé une autre semaine pour terminer la révision finale des prototypes.", pt: "Eles pediram mais uma semana para concluir a revisão final dos protótipos.", isBot: false),
      SpeakingMessage(en: "Je peux prolonger la date limite, mais nous devons lancer avant les vacances.", pt: "Posso estender o prazo, mas devemos lançar antes do feriado.", isBot: true),
      SpeakingMessage(en: "D'accord. Je vais coordonner avec le développement pour accélérer la programmation.", pt: "Acordado. Vou coordenar com o desenvolvimento para acelerar a programação.", isBot: false),
      SpeakingMessage(en: "Excellent. Réunissons-nous à nouveau jeudi pour vérifier le nouveau calendrier.", pt: "Excelente. Vamos nos reunir novamente na quinta-feira para checar o novo cronograma.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 16,
    title: "Abrindo uma Conta Bancária",
    description: "Pergunte sobre taxas de juros, taxas mensais e cartões de crédito.",
    level: SpeakingLevel.advanced,
    icon: Icons.account_balance_rounded,
    messages: [
      SpeakingMessage(en: "Bonjour. Comment puis-je vous aider à ouvrir un compte aujourd'hui ?", pt: "Bom dia. Como posso ajudá-lo a abrir uma conta hoje?", isBot: true),
      SpeakingMessage(en: "Je voudrais ouvrir un compte courant avec des frais mensuels bas.", pt: "Gostaria de abrir uma conta corrente com baixas taxas mensais.", isBot: false),
      SpeakingMessage(en: "Nous avons un compte de base sans frais si vous maintenez un solde minimum.", pt: "Temos uma conta básica sem taxas se você mantiver um saldo mínimo.", isBot: true),
      SpeakingMessage(en: "Quel est le solde minimum requis pour éviter les frais mensuels ?", pt: "Qual é o saldo mínimo exigido para isentar a taxa mensal?", isBot: false),
      SpeakingMessage(en: "C'est mille dollars. Est-ce que cela convient à votre budget ?", pt: "É de mil dólares. Isso funciona para o seu orçamento?", isBot: true),
      SpeakingMessage(en: "Oui, c'est bon. Ce compte comprend-il une carte de crédit ?", pt: "Sim, está ótimo. Esta conta inclui um cartão de crédito?", isBot: false),
      SpeakingMessage(en: "We can apply for one, subject to a credit check and approval.", pt: "Podemos solicitar um, sujeito a uma verificação e aprovação de crédito.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 17,
    title: "Problemas com Aluguel de Carro",
    description: "Negocie reparos ou reclame sobre um carro alugado danificado.",
    level: SpeakingLevel.advanced,
    icon: Icons.car_rental_rounded,
    messages: [
      SpeakingMessage(en: "Bon retour. Avez-vous rencontré des problèmes avec le véhicule ?", pt: "Bem-vindo de volta. Você teve algum problema com o veículo?", isBot: true),
      SpeakingMessage(en: "Oui, la climatisation a cessé de fonctionner le deuxième jour.", pt: "Sim, o ar condicionado parou de funcionar no segundo dia.", isBot: false),
      SpeakingMessage(en: "Je m'excuse pour ce désagrément. L'avez-vous signalé pendant la location ?", pt: "Peço desculpas pelo inconveniente. Você relatou isso durante o aluguel?", isBot: true),
      SpeakingMessage(en: "J'ai essayé d'appeler, mais votre service client était complètement saturé.", pt: "Tentei ligar, mas a sua linha de atendimento ao cliente estava totalmente ocupada.", isBot: false),
      SpeakingMessage(en: "Je comprends. Je peux vous offrir une réduction de 20% sur votre facture totale.", pt: "Eu entendo. Posso oferecer um desconto de vinte por cento na sua fatura total.", isBot: true),
      SpeakingMessage(en: "J'apprécie l'offre, mais j'attends un remboursement complet pour ces jours-là.", pt: "Agradeço a oferta, mas espero um reembolso total por esses dias.", isBot: false),
      SpeakingMessage(en: "Laissez-moi vérifier avec mon responsable si nous pouvons traiter un remboursement plus important.", pt: "Deixe-me verificar com meu gerente se podemos processar um reembolso maior.", isBot: true),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 18,
    title: "Debatendo Planos",
    description: "Use expressões idiomáticas para expressar desacordos e chegar a um acordo.",
    level: SpeakingLevel.native,
    icon: Icons.lightbulb_rounded,
    messages: [
      SpeakingMessage(en: "Je pensais que nous pourrions organiser l'événement en plein air cette année.", pt: "Estava pensando que poderíamos sediar o evento ao ar livre este ano.", isBot: true),
      SpeakingMessage(en: "Je ne sais pas, c'est un peu risqué avec la météo du printemps.", pt: "Não sei, isso é um pouco arriscado com o tempo da primavera.", isBot: false),
      SpeakingMessage(en: "C'est juste, mais cela nous ferait économiser beaucoup d'argent sur les frais de salle.", pt: "Justo, mas nos economizaria um bom dinheiro nas taxas do local.", isBot: true),
      SpeakingMessage(en: "C'est vrai, mais s'il pleut, nous serons de retour à la case départ sans rien.", pt: "Verdade, mas se chover, voltaremos à estaca zero sem nada.", isBot: false),
      SpeakingMessage(en: "C'est vrai. Et si nous louions une tente comme plan de secours ?", pt: "Point taken. What if we rent a tent as a backup plan?", isBot: true),
      SpeakingMessage(en: "Ça marche. Faisons un compromis et réservons un endroit semi-couvert.", pt: "Isso funciona. Vamos chegar a um meio-termo e reservar um local semi-coberto.", isBot: false),
    ],
  ),
  const SpeakingScenario(
    id: 19,
    title: "Reclamando do Tempo",
    description: "Converse como um falante nativo sobre o tempo ruim inesperado.",
    level: SpeakingLevel.native,
    icon: Icons.cloudy_snowing,
    messages: [
      SpeakingMessage(en: "Tu as vu ce temps ? Il pleut des cordes dehors !", pt: "Dá para acreditar nesse tempo? Está chovendo canivete lá fora!", isBot: true),
      SpeakingMessage(en: "Tu m'étonnes ! Mon parapluie s'est complètement retourné.", pt: "Nem me fale! Meu guarda-chuva virou completamente do avesso.", isBot: false),
      SpeakingMessage(en: "Le mien aussi ! J'ai été complètement trempé juste en marchant depuis la voiture.", pt: "O meu também! Fiquei totalmente encharcado só de andar do carro até aqui.", isBot: true),
      SpeakingMessage(en: "Et le pire, c'est que la météo annonce que ça va durer toute la semaine.", pt: "E a pior parte é que a previsão diz que vai durar a semana toda.", isBot: false),
      SpeakingMessage(en: "Oh non, c'est une blague ! J'espérais avoir un peu de soleil.", pt: "Ah, você só pode estar brincando comigo. Eu estava esperando um pouco de sol.", isBot: true),
      SpeakingMessage(en: "Pas de chance, on dirait. Nous sommes coincés à l'intérieur pour le week-end.", pt: "Sem sorte, pelo jeito. Estamos presos dentro de casa no fim de semana.", isBot: false),
    ],
  ),
  const SpeakingScenario(
    id: 20,
    title: "Conversando sobre um Filme",
    description: "Discuta reviravoltas na história e avalie um filme usando expressões cotidianas.",
    level: SpeakingLevel.native,
    icon: Icons.movie_rounded,
    messages: [
      SpeakingMessage(en: "Alors, tu as enfin regardé ce thriller dont tout le monde parle ?", pt: "E aí, você finalmente assistiu àquele suspense de que todo mundo está falando?", isBot: true),
      SpeakingMessage(en: "Oui, je l'ai regardé hier soir. Le rebondissement m'a bluffé !", pt: "Sim, assisti ontem à noite. A reviravolta na história explodiu minha cabeça!", isBot: false),
      SpeakingMessage(en: "N'est-ce pas ? Je ne m'y attendais pas du tout ! Ça m'a tenu en haleine tout le long.", pt: "Né? Eu não esperava por aquilo de jeito nenhum! Me manteve na beira da cadeira.", isBot: true),
      SpeakingMessage(en: "Exactement. L'acteur principal a vraiment assuré dans sa performance.", pt: "Exatamente. O ator principal realmente arrebentou com a atuação dele.", isBot: false),
      SpeakingMessage(en: "C'est clair. Mais la fin a semblé un peu précipitée, tu ne trouves pas ?", pt: "Ele arrebentou mesmo. Mas o final pareceu um pouco apressado, você não acha?", isBot: true),
      SpeakingMessage(en: "Un peu, oui. Dans l'ensemble, cependant, ça valait vraiment le coup.", pt: "Um pouco, sim. No geral, no entanto, valeu cada centavo.", isBot: false),
    ],
  ),
];
