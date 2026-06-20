import 'package:flutter/material.dart';

enum SpeakingLevel { basic, intermediate, advanced, native }

class SpeakingMessage {
  final String en;
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
    title: "At the Cafe",
    description: "Learn to order your favorite coffee and a pastry.",
    level: SpeakingLevel.basic,
    icon: Icons.coffee_rounded,
    messages: [
      SpeakingMessage(en: "Hello! Welcome to our cafe. What can I get for you today?", pt: "Olá! Bem-vindo ao nosso café. O que posso te servir hoje?", isBot: true),
      SpeakingMessage(en: "I would like a hot cappuccino and a chocolate croissant, please.", pt: "Eu gostaria de um cappuccino quente e um croissant de chocolate, por favor.", isBot: false),
      SpeakingMessage(en: "Sure! What size cappuccino would you like? Small, medium, or large?", pt: "Claro! Qual tamanho de cappuccino você gostaria? Pequeno, médio ou grande?", isBot: true),
      SpeakingMessage(en: "A medium cappuccino is perfect, thank you.", pt: "Um cappuccino médio é perfeito, obrigado.", isBot: false),
      SpeakingMessage(en: "Great! That will be six dollars. Will that be cash or card?", pt: "Ótimo! Fica em seis dólares. Será em dinheiro ou cartão?", isBot: true),
      SpeakingMessage(en: "I will pay with card. Here you go.", pt: "Vou pagar com cartão. Aqui está.", isBot: false),
      SpeakingMessage(en: "Thank you. Your order will be ready at the counter in a minute.", pt: "Obrigado. Seu pedido estará pronto no balcão em um minuto.", isBot: true),
    ],
  ),

  // ==========================================
  // INTERMEDIATE LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 2,
    title: "Hotel Check-in",
    description: "Practice checking into your hotel and asking about amenities.",
    level: SpeakingLevel.intermediate,
    icon: Icons.hotel_rounded,
    messages: [
      SpeakingMessage(en: "Good afternoon. Welcome to the Grand Plaza Hotel. Do you have a reservation?", pt: "Boa tarde. Bem-vindo ao Grand Plaza Hotel. Você tem uma reserva?", isBot: true),
      SpeakingMessage(en: "Yes, I have a reservation under the name John Smith.", pt: "Sim, eu tenho uma reserva sob o nome de John Smith.", isBot: false),
      SpeakingMessage(en: "Ah, yes, Mr. Smith. A deluxe double room for three nights. Is that correct?", pt: "Ah, sim, Sr. Smith. Um quarto duplo de luxo por três noites. Está correto?", isBot: true),
      SpeakingMessage(en: "That is correct. Is breakfast included in my stay?", pt: "Está correto. O café da manhã está incluso na minha estadia?", isBot: false),
      SpeakingMessage(en: "Yes, breakfast is served from seven to ten in the main restaurant. Here are your keys.", pt: "Sim, o café da manhã é servido das sete às dez no restaurante principal. Aqui estão suas chaves.", isBot: true),
      SpeakingMessage(en: "Perfect. Where is the gym located and do I need a code?", pt: "Perfeito. Onde a academia fica localizada e eu preciso de um código?", isBot: false),
      SpeakingMessage(en: "The gym is on the second floor and you can access it with your room key.", pt: "A academia fica no segundo andar e você pode acessá-la com a chave do seu quarto.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 3,
    title: "Job Interview",
    description: "Discuss your strengths and professional experiences.",
    level: SpeakingLevel.advanced,
    icon: Icons.work_rounded,
    messages: [
      SpeakingMessage(en: "Thank you for coming in today. To start off, could you tell me a bit about your background?", pt: "Obrigado por vir hoje. Para começar, você poderia me contar um pouco sobre o seu histórico?", isBot: true),
      SpeakingMessage(en: "I have been working as a software developer for five years, specializing in mobile apps.", pt: "Trabalho como desenvolvedor de software há cinco anos, me especializando em aplicativos móveis.", isBot: false),
      SpeakingMessage(en: "That sounds impressive. Can you describe a challenging project you successfully managed?", pt: "Isso parece impressionante. Você pode descrever um projeto desafiador que gerenciou com sucesso?", isBot: true),
      SpeakingMessage(en: "I recently led a team to redesign our core app, reducing loading times by forty percent.", pt: "Recentemente liderei uma equipe para redesenhar nosso aplicativo principal, reduzindo o tempo de carregamento em quarenta por cento.", isBot: false),
      SpeakingMessage(en: "Excellent. Why do you believe you are the right fit for this position in our company?", pt: "Excelente. Por que você acredita que é a pessoa certa para esta posição em nossa empresa?", isBot: true),
      SpeakingMessage(en: "I bring a strong work ethic, technical expertise, and a passion for building user-friendly products.", pt: "Trago uma forte ética de trabalho, experiência técnica e paixão por criar produtos fáceis de usar.", isBot: false),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 4,
    title: "Asking for a Favor",
    description: "Use natural idioms and slangs to ask a friend for a big favor.",
    level: SpeakingLevel.native,
    icon: Icons.handshake_rounded,
    messages: [
      SpeakingMessage(en: "Hey buddy, do you have a second? I really need to run something by you.", pt: "Ei cara, você tem um segundo? Eu realmente preciso falar uma coisa com você.", isBot: true),
      SpeakingMessage(en: "Sure thing, what's up? You look a bit stressed out, is everything okay?", pt: "Claro, o que houve? Você parece um pouco estressado, está tudo bem?", isBot: false),
      SpeakingMessage(en: "To be honest, I'm in a tight spot. My car broke down and I need to drop my sister off at the airport.", pt: "Para falar a verdade, estou em apuros. Meu carro quebrou e preciso levar minha irmã ao aeroporto.", isBot: true),
      SpeakingMessage(en: "No worries! I can drive her. We go way back, so it's really no big deal.", pt: "Não se preocupe! Eu posso levá-la. Nós somos velhos amigos, então realmente não é grande coisa.", isBot: false),
      SpeakingMessage(en: "Oh man, you are a lifesaver! I owe you big time for this, seriously.", pt: "Cara, você salvou minha vida! Te devo uma grande por causa disso, sério.", isBot: true),
      SpeakingMessage(en: "Don't sweat it. Just pay it forward next time I'm in a pinch.", pt: "Nem esquenta com isso. Apenas retribua o favor na próxima vez que eu estiver em apuros.", isBot: false),
    ],
  ),

  // ==========================================
  // BASIC LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 5,
    title: "Asking for Directions",
    description: "Learn how to ask for and understand simple directions.",
    level: SpeakingLevel.basic,
    icon: Icons.map_rounded,
    messages: [
      SpeakingMessage(en: "Excuse me, do you know where the nearest subway station is?", pt: "Com licença, você sabe onde fica a estação de metrô mais próxima?", isBot: true),
      SpeakingMessage(en: "Yes, go straight for two blocks and then turn left.", pt: "Sim, vá reto por duas quadras e depois vire à esquerda.", isBot: false),
      SpeakingMessage(en: "Thank you! Is it far from here or can I walk?", pt: "Obrigado! Fica longe daqui ou eu posso ir andando?", isBot: true),
      SpeakingMessage(en: "It is very close. It takes only five minutes to walk there.", pt: "É muito perto. Leva apenas cinco minutos para ir andando até lá.", isBot: false),
      SpeakingMessage(en: "Perfect, thanks a lot for your help! Have a great day!", pt: "Perfeito, muito obrigado pela sua ajuda! Tenha um ótimo dia!", isBot: true),
      SpeakingMessage(en: "You are welcome. Have a safe trip!", pt: "De nada. Tenha uma boa viagem!", isBot: false),
    ],
  ),

  // ==========================================
  // INTERMEDIATE LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 6,
    title: "Doctor's Appointment",
    description: "Describe symptoms to a doctor and get medical advice.",
    level: SpeakingLevel.intermediate,
    icon: Icons.local_hospital_rounded,
    messages: [
      SpeakingMessage(en: "Good morning. What seems to be the problem today?", pt: "Bom dia. Qual parece ser o problema hoje?", isBot: true),
      SpeakingMessage(en: "I have had a bad headache and a sore throat since yesterday.", pt: "Estou com uma forte dor de cabeça e dor de garganta desde ontem.", isBot: false),
      SpeakingMessage(en: "Do you also have a fever or a cough?", pt: "Você também tem febre ou tosse?", isBot: true),
      SpeakingMessage(en: "I had a mild fever last night, but no cough.", pt: "Tive uma febre leve ontem à noite, mas sem tosse.", isBot: false),
      SpeakingMessage(en: "I see. I will prescribe some medicine. Rest and drink plenty of water.", pt: "Entendo. Vou receitar alguns remédios. Descanse e beba bastante água.", isBot: true),
      SpeakingMessage(en: "Thank you, doctor. How often should I take the medicine?", pt: "Obrigado, doutor. Com que frequência devo tomar o remédio?", isBot: false),
      SpeakingMessage(en: "Take one pill every eight hours after meals.", pt: "Tome um comprimido a cada oito horas após as refeições.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 7,
    title: "Negotiating Rent",
    description: "Discuss rental terms, prices, and contracts for an apartment.",
    level: SpeakingLevel.advanced,
    icon: Icons.real_estate_agent_rounded,
    messages: [
      SpeakingMessage(en: "Hi, thanks for visiting the apartment. What do you think of the lease agreement?", pt: "Olá, obrigado por visitar o apartamento. O que você acha do contrato de aluguel?", isBot: true),
      SpeakingMessage(en: "The apartment is great, but the monthly rent is slightly above my budget.", pt: "O apartamento é ótimo, mas o aluguel mensal está um pouco acima do meu orçamento.", isBot: false),
      SpeakingMessage(en: "I understand, but it includes water and a private parking space. What price were you thinking of?", pt: "Eu entendo, mas inclui água e uma vaga de estacionamento privativa. Que preço você tinha em mente?", isBot: true),
      SpeakingMessage(en: "Would you consider a five percent discount if I sign a two-year contract?", pt: "Você consideraria um desconto de cinco por cento se eu assinar um contrato de dois anos?", isBot: false),
      SpeakingMessage(en: "That sounds reasonable. If you sign for two years, I can lower the price.", pt: "Isso parece razoável. Se você assinar por dois anos, posso baixar o preço.", isBot: true),
      SpeakingMessage(en: "Excellent. Can we update the contract and sign it next Monday?", pt: "Excelente. Podemos atualizar o contrato e assiná-lo na próxima segunda-feira?", isBot: false),
      SpeakingMessage(en: "Yes, I will prepare the revised lease and email it to you tomorrow.", pt: "Sim, vou preparar o contrato revisado e enviar por e-mail para você amanhã.", isBot: true),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 8,
    title: "Catching Up",
    description: "Use expressions and slang to talk about a weekend trip with a friend.",
    level: SpeakingLevel.native,
    icon: Icons.people_rounded,
    messages: [
      SpeakingMessage(en: "Long time no see! You've got to tell me all about your weekend getaway.", pt: "Há quanto tempo! Você tem que me contar tudo sobre a sua viagem de fim de semana.", isBot: true),
      SpeakingMessage(en: "Oh, it was a blast! We hit the beach and just chilled out the whole time.", pt: "Ah, foi sensacional! Nós fomos para a praia e apenas relaxamos o tempo todo.", isBot: false),
      SpeakingMessage(en: "No way! I'm so jealous. Did you catch that new seafood joint by the pier?", pt: "Não brinca! Que inveja. Vocês foram àquele novo restaurante de frutos do mar perto do píer?", isBot: true),
      SpeakingMessage(en: "Yeah, we did! It was a bit pricey, but the food was out of this world.", pt: "Sim, nós fomos! Foi um pouco caro, mas a comida estava fora desse mundo.", isBot: false),
      SpeakingMessage(en: "Awesome. I've been meaning to check it out. Let's hang out soon and plan one together.", pt: "Incrível. Estou querendo ir lá faz tempo. Vamos nos encontrar logo e planejar uma juntos.", isBot: true),
      SpeakingMessage(en: "For sure! Let's touch base next week and iron out the details.", pt: "Com certeza! Vamos nos falar na próxima semana e acertar os detalhes.", isBot: false),
    ],
  ),

  // ==========================================
  // BASIC LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 9,
    title: "Buying a Train Ticket",
    description: "Learn how to ask for ticket prices and times at the station.",
    level: SpeakingLevel.basic,
    icon: Icons.train_rounded,
    messages: [
      SpeakingMessage(en: "Hello! How can I help you today?", pt: "Olá! Como posso te ajudar hoje?", isBot: true),
      SpeakingMessage(en: "I would like one ticket to London, please.", pt: "Eu gostaria de uma passagem para Londres, por favor.", isBot: false),
      SpeakingMessage(en: "Single or return ticket? And for which time?", pt: "Passagem de ida ou ida e volta? E para qual horário?", isBot: true),
      SpeakingMessage(en: "A single ticket for the next train, please.", pt: "Uma passagem de ida para o próximo trem, por favor.", isBot: false),
      SpeakingMessage(en: "The next train leaves at ten. That will be fifteen dollars.", pt: "O próximo trem sai às dez. Fica em quinze dólares.", isBot: true),
      SpeakingMessage(en: "Here is the money. Which platform is it?", pt: "Aqui está o dinheiro. Qual é a plataforma?", isBot: false),
      SpeakingMessage(en: "It is platform four. Have a good trip!", pt: "É a plataforma quatro. Tenha uma boa viagem!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 10,
    title: "Introducing Yourself",
    description: "Practice saying your name, where you are from, and your age.",
    level: SpeakingLevel.basic,
    icon: Icons.person_pin_rounded,
    messages: [
      SpeakingMessage(en: "Hi there! I am Sarah. What is your name?", pt: "Olá! Eu sou a Sarah. Qual é o seu nome?", isBot: true),
      SpeakingMessage(en: "Hello Sarah! My name is Lucas. Nice to meet you.", pt: "Olá Sarah! Meu nome é Lucas. Prazer em te conhecer.", isBot: false),
      SpeakingMessage(en: "Nice to meet you too, Lucas. Where are you from?", pt: "Prazer em te conhecer também, Lucas. De onde você é?", isBot: true),
      SpeakingMessage(en: "I am from Brazil, but I live in New York now.", pt: "Eu sou do Brasil, mas moro em Nova York agora.", isBot: false),
      SpeakingMessage(en: "Oh, that is great! How old are you, if I may ask?", pt: "Ah, isso é ótimo! Quantos anos você tem, se me permite perguntar?", isBot: true),
      SpeakingMessage(en: "I am twenty-five years old. What about you?", pt: "Eu tenho vinte e cinco anos. E você?", isBot: false),
      SpeakingMessage(en: "I am twenty-eight. I hope you enjoy your time here!", pt: "Eu tenho vinte e oito. Espero que você aproveite seu tempo aqui!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 11,
    title: "At the Supermarket",
    description: "Learn to ask for prices and find items in a grocery store.",
    level: SpeakingLevel.basic,
    icon: Icons.shopping_cart_rounded,
    messages: [
      SpeakingMessage(en: "Excuse me, sir. Do you need help finding anything?", pt: "Com licença, senhor. Precisa de ajuda para encontrar algo?", isBot: true),
      SpeakingMessage(en: "Yes, please. Where can I find the fresh milk?", pt: "Sim, por favor. Onde posso encontrar o leite fresco?", isBot: false),
      SpeakingMessage(en: "It is in aisle three, next to the cheese.", pt: "Fica no corredor três, ao lado do queijo.", isBot: true),
      SpeakingMessage(en: "Thank you. And how much is a bag of apples?", pt: "Obrigado. E quanto custa um saco de maçãs?", isBot: false),
      SpeakingMessage(en: "They are four dollars per kilo today.", pt: "Estão quatro dólares o quilo hoje.", isBot: true),
      SpeakingMessage(en: "Great, I will take a kilo. Where is the cashier?", pt: "Ótimo, vou levar um quilo. Onde fica o caixa?", isBot: false),
      SpeakingMessage(en: "The cashiers are at the front of the store.", pt: "Os caixas ficam na frente da loja.", isBot: true),
    ],
  ),

  // ==========================================
  // INTERMEDIATE LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 12,
    title: "Ordering Food Delivery",
    description: "Call a restaurant to order food and ask about delivery times.",
    level: SpeakingLevel.intermediate,
    icon: Icons.delivery_dining_rounded,
    messages: [
      SpeakingMessage(en: "Thank you for calling Pizza Palace. Would you like to place an order?", pt: "Obrigado por ligar para o Pizza Palace. Gostaria de fazer um pedido?", isBot: true),
      SpeakingMessage(en: "Yes, I would like a large pepperoni pizza and a bottle of soda.", pt: "Sim, eu gostaria de uma pizza grande de pepperoni e uma garrafa de refrigerante.", isBot: false),
      SpeakingMessage(en: "Sure. Is that for pickup or delivery to your home?", pt: "Claro. É para retirar ou entrega na sua casa?", isBot: true),
      SpeakingMessage(en: "It is for delivery to main street, house number twelve.", pt: "É para entrega na rua principal, casa número doze.", isBot: false),
      SpeakingMessage(en: "Perfect. The total comes to twenty-five dollars. How will you pay?", pt: "Perfeito. O total fica em vinte e cinco dólares. Como irá pagar?", isBot: true),
      SpeakingMessage(en: "I will pay with cash on delivery. How long will it take?", pt: "Vou pagar com dinheiro na entrega. Quanto tempo vai levar?", isBot: false),
      SpeakingMessage(en: "It should arrive in about thirty to forty minutes. Thank you!", pt: "Deve chegar em cerca de trinta a quarenta minutos. Obrigado!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 13,
    title: "Reporting a Lost Item",
    description: "Describe a lost bag to airport security or hotel staff.",
    level: SpeakingLevel.intermediate,
    icon: Icons.find_in_page_rounded,
    messages: [
      SpeakingMessage(en: "Lost and Found department. How can I assist you today?", pt: "Departamento de Achados e Perdidos. Como posso te ajudar hoje?", isBot: true),
      SpeakingMessage(en: "I think I left my backpack on the flight from Miami.", pt: "Acho que deixei minha mochila no voo vindo de Miami.", isBot: false),
      SpeakingMessage(en: "Can you describe the backpack and tell me your flight number?", pt: "Você pode descrever a mochila e me dizer o número do seu voo?", isBot: true),
      SpeakingMessage(en: "It is a black leather backpack with two big side pockets.", pt: "É uma mochila de couro preta com dois bolsos laterais grandes.", isBot: false),
      SpeakingMessage(en: "And did it have any name tag or identification on it?", pt: "E ela tinha alguma etiqueta de nome ou identificação?", isBot: true),
      SpeakingMessage(en: "Yes, there is a small blue tag with my name, John Doe.", pt: "Sim, há uma pequena etiqueta azul com meu nome, John Doe.", isBot: false),
      SpeakingMessage(en: "Okay. We will check the cabin and contact you if we find it.", pt: "Tudo bem. Vamos verificar a cabine e entraremos em contato se a encontrarmos.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 14,
    title: "Asking for Recommendations",
    description: "Ask a local for tourist recommendations and dining places.",
    level: SpeakingLevel.intermediate,
    icon: Icons.recommend_rounded,
    messages: [
      SpeakingMessage(en: "Welcome to our visitor center! Are you looking for anything specific?", pt: "Bem-vindo ao nosso centro de visitantes! Está procurando por algo específico?", isBot: true),
      SpeakingMessage(en: "I have two days here. What are the best sights to see?", pt: "Tenho dois dias aqui. Quais são os melhores pontos turísticos para ver?", isBot: false),
      SpeakingMessage(en: "You should visit the historic castle and take a boat tour.", pt: "Você deve visitar o castelo histórico e fazer um passeio de barco.", isBot: true),
      SpeakingMessage(en: "That sounds fun. Do you know a good local restaurant nearby?", pt: "Isso parece divertido. Você conhece um bom restaurante local por perto?", isBot: false),
      SpeakingMessage(en: "The Seafood Grill near the harbor serves excellent local dishes.", pt: "O Seafood Grill perto do porto serve excelentes pratos locais.", isBot: true),
      SpeakingMessage(en: "Do I need to make a reservation for dinner there?", pt: "Eu preciso fazer uma reserva para o jantar lá?", isBot: false),
      SpeakingMessage(en: "It gets busy on weekends, so I recommend calling in advance.", pt: "Fica movimentado nos fins de semana, então recomendo ligar com antecedência.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 15,
    title: "Business Meeting",
    description: "Discuss project deadlines and team roles in a professional setting.",
    level: SpeakingLevel.advanced,
    icon: Icons.co_present_rounded,
    messages: [
      SpeakingMessage(en: "Thanks for joining. Let's discuss the project timeline for next quarter.", pt: "Obrigado por participar. Vamos discutir o cronograma do projeto para o próximo trimestre.", isBot: true),
      SpeakingMessage(en: "We need to adjust the deadline because the design is delayed.", pt: "Precisamos ajustar o prazo porque o design está atrasado.", isBot: false),
      SpeakingMessage(en: "How much extra time does the design team need to finalize the layout?", pt: "De quanto tempo extra a equipe de design precisa para finalizar o layout?", isBot: true),
      SpeakingMessage(en: "They requested another week to complete the final review of prototypes.", pt: "Eles pediram mais uma semana para concluir a revisão final dos protótipos.", isBot: false),
      SpeakingMessage(en: "I can extend the deadline, but we must launch before the holiday.", pt: "Posso estender o prazo, mas devemos lançar antes do feriado.", isBot: true),
      SpeakingMessage(en: "Agreed. I will coordinate with development to speed up the coding.", pt: "Acordado. Vou coordenar com o desenvolvimento para acelerar a programação.", isBot: false),
      SpeakingMessage(en: "Excellent. Let's meet again on Thursday to check the new schedule.", pt: "Excelente. Vamos nos reunir novamente na quinta-feira para checar o novo cronograma.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 16,
    title: "Opening a Bank Account",
    description: "Ask about interest rates, monthly fees, and credit cards.",
    level: SpeakingLevel.advanced,
    icon: Icons.account_balance_rounded,
    messages: [
      SpeakingMessage(en: "Good morning. How can I help you open an account today?", pt: "Bom dia. Como posso ajudá-lo a abrir uma conta hoje?", isBot: true),
      SpeakingMessage(en: "I would like to open a checking account with low monthly fees.", pt: "Gostaria de abrir uma conta corrente com baixas taxas mensais.", isBot: false),
      SpeakingMessage(en: "We have a basic account with no fees if you maintain a minimum balance.", pt: "Temos uma conta básica sem taxas se você mantiver um saldo mínimo.", isBot: true),
      SpeakingMessage(en: "What is the minimum balance required to waive the monthly fee?", pt: "Qual é o saldo mínimo exigido para isentar a taxa mensal?", isBot: false),
      SpeakingMessage(en: "It is one thousand dollars. Does that work for your budget?", pt: "É de mil dólares. Isso funciona para o seu orçamento?", isBot: true),
      SpeakingMessage(en: "Yes, that is fine. Does this account include a credit card?", pt: "Sim, está ótimo. Esta conta inclui um cartão de crédito?", isBot: false),
      SpeakingMessage(en: "We can apply for one, subject to a credit check and approval.", pt: "Podemos solicitar um, sujeito a uma verificação e aprovação de crédito.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 17,
    title: "Car Rental Issues",
    description: "Negotiate repairs or complain about a damaged rental car.",
    level: SpeakingLevel.advanced,
    icon: Icons.car_rental_rounded,
    messages: [
      SpeakingMessage(en: "Welcome back. Did you experience any issues with the vehicle?", pt: "Bem-vindo de volta. Você teve algum problema com o veículo?", isBot: true),
      SpeakingMessage(en: "Yes, the air conditioning stopped working on the second day.", pt: "Sim, o ar condicionado parou de funcionar no segundo dia.", isBot: false),
      SpeakingMessage(en: "I apologize for that inconvenience. Did you report it during the rental?", pt: "Peço desculpas pelo inconveniente. Você relatou isso durante o aluguel?", isBot: true),
      SpeakingMessage(en: "I tried calling, but your customer service line was completely busy.", pt: "Tentei ligar, mas a sua linha de atendimento ao cliente estava totalmente ocupada.", isBot: false),
      SpeakingMessage(en: "I understand. I can offer a twenty percent discount on your total bill.", pt: "Eu entendo. Posso oferecer um desconto de vinte por cento na sua fatura total.", isBot: true),
      SpeakingMessage(en: "I appreciate the offer, but I expect a full refund for those days.", pt: "Agradeço a oferta, mas espero um reembolso total por esses dias.", isBot: false),
      SpeakingMessage(en: "Let me check with my manager if we can process a larger refund.", pt: "Deixe-me verificar com meu gerente se podemos processar um reembolso maior.", isBot: true),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL (ADDITIONAL SET 2)
  // ==========================================
  const SpeakingScenario(
    id: 18,
    title: "Debating Plans",
    description: "Use idioms to voice disagreements and reach a compromise.",
    level: SpeakingLevel.native,
    icon: Icons.lightbulb_rounded,
    messages: [
      SpeakingMessage(en: "I was thinking we could host the event outdoors this year.", pt: "Estava pensando que poderíamos sediar o evento ao ar livre este ano.", isBot: true),
      SpeakingMessage(en: "I don't know, that's a bit of a gamble with the spring weather.", pt: "Não sei, isso é um pouco arriscado com o tempo da primavera.", isBot: false),
      SpeakingMessage(en: "Fair enough, but it would save us a pretty penny on venue fees.", pt: "Justo, mas nos economizaria um bom dinheiro nas taxas do local.", isBot: true),
      SpeakingMessage(en: "True, but if it rains, we'll be back to square one with nothing.", pt: "Verdade, mas se chover, voltaremos à estaca zero sem nada.", isBot: false),
      SpeakingMessage(en: "Point taken. What if we rent a tent as a backup plan?", pt: "Entendido. E se alugarmos uma tenda como um plano de reserva?", isBot: true),
      SpeakingMessage(en: "That works. Let's meet halfway and book a semi-outdoor spot.", pt: "Isso funciona. Vamos chegar a um meio-termo e reservar um local semi-coberto.", isBot: false),
    ],
  ),
  const SpeakingScenario(
    id: 19,
    title: "Complaining about Weather",
    description: "Chat like a native speaker about unexpected bad weather.",
    level: SpeakingLevel.native,
    icon: Icons.cloudy_snowing,
    messages: [
      SpeakingMessage(en: "Can you believe this weather? It's raining cats and dogs out there!", pt: "Dá para acreditar nesse tempo? Está chovendo canivete lá fora!", isBot: true),
      SpeakingMessage(en: "Tell me about it! My umbrella got completely blown inside out.", pt: "Nem me fale! Meu guarda-chuva virou completamente do avesso.", isBot: false),
      SpeakingMessage(en: "Mine too! I got absolutely soaked just walking from the car.", pt: "O meu também! Fiquei totalmente encharcado só de andar do carro até aqui.", isBot: true),
      SpeakingMessage(en: "And the worst part is the forecast says it will last all week.", pt: "E a pior parte é que a previsão diz que vai durar a semana toda.", isBot: false),
      SpeakingMessage(en: "Oh, you've got to be kidding me. I was hoping for some sunshine.", pt: "Ah, você só pode estar brincando comigo. Eu estava esperando um pouco de sol.", isBot: true),
      SpeakingMessage(en: "No such luck, I guess. We are stuck indoors for the weekend.", pt: "Sem sorte, pelo jeito. Estamos presos dentro de casa no fim de semana.", isBot: false),
    ],
  ),
  const SpeakingScenario(
    id: 20,
    title: "Talking about a Movie",
    description: "Discuss plot twists and review a film using everyday expressions.",
    level: SpeakingLevel.native,
    icon: Icons.movie_rounded,
    messages: [
      SpeakingMessage(en: "So, did you finally watch that thriller everyone is talking about?", pt: "E aí, você finalmente assistiu àquele suspense de que todo mundo está falando?", isBot: true),
      SpeakingMessage(en: "Yeah, I watched it last night. The plot twist blew my mind!", pt: "Sim, assisti ontem à noite. A reviravolta na história explodiu minha cabeça!", isBot: false),
      SpeakingMessage(en: "Right? I did not see that coming at all! It kept me on the edge of my seat.", pt: "Né? Eu não esperava por aquilo de jeito nenhum! Me manteve na beira da cadeira.", isBot: true),
      SpeakingMessage(en: "Exactly. The lead actor really hit it out of the park with his performance.", pt: "Exatamente. O ator principal realmente arrebentou com a atuação dele.", isBot: false),
      SpeakingMessage(en: "He sure did. But the ending felt a bit rushed, don't you think?", pt: "Ele arrebentou mesmo. Mas o final pareceu um pouco apressado, você não acha?", isBot: true),
      SpeakingMessage(en: "A little bit, yeah. Overall, though, it was worth every penny.", pt: "Um pouco, sim. No geral, no entanto, valeu cada centavo.", isBot: false),
    ],
  ),
];
