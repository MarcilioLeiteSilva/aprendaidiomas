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
    description: "Aprenda a pedir seu café favorito e um doce em espanhol.",
    level: SpeakingLevel.basic,
    icon: Icons.coffee_rounded,
    messages: [
      SpeakingMessage(en: "¡Hola! Bienvenido a nuestro café. ¿Qué le puedo servir hoy?", pt: "Olá! Bem-vindo ao nosso café. O que posso te servir hoje?", isBot: true),
      SpeakingMessage(en: "Me gustaría un capuchino caliente y un cruasán de chocolate, por favor.", pt: "Eu gostaria de um cappuccino quente e um croissant de chocolate, por favor.", isBot: false),
      SpeakingMessage(en: "¡Claro! ¿Qué tamanho de capuchino desea? ¿Pequeno, mediano o grande?", pt: "Claro! Qual tamanho de cappuccino você gostaria? Pequeno, médio ou grande?", isBot: true),
      SpeakingMessage(en: "Un capuchino mediano está perfeito, gracias.", pt: "Um cappuccino médio é perfeito, obrigado.", isBot: false),
      SpeakingMessage(en: "¡Excelente! Serán seis dólares. ¿Será en efectivo o con tarjeta?", pt: "Ótimo! Fica em seis dólares. Será em dinheiro ou cartão?", isBot: true),
      SpeakingMessage(en: "Pagaré con tarjeta. Aquí tiene.", pt: "Vou pagar com cartão. Aqui está.", isBot: false),
      SpeakingMessage(en: "Gracias. Su pedido estará listo en la barra en un minuto.", pt: "Obrigado. Seu pedido estará pronto no balcão em um minuto.", isBot: true),
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
      SpeakingMessage(en: "Buenos días. Bienvenido al Grand Plaza Hotel. ¿Tiene una reserva?", pt: "Boa tarde. Bem-vindo ao Grand Plaza Hotel. Você tem uma reserva?", isBot: true),
      SpeakingMessage(en: "Sí, tengo una reserva a nombre de John Smith.", pt: "Sim, eu tenho uma reserva sob o nome de John Smith.", isBot: false),
      SpeakingMessage(en: "Ah sí, señor Smith. Una habitación doble de lujo por três noches. ¿Es correcto?", pt: "Ah, sim, Sr. Smith. Um quarto duplo de luxo por três noites. Está correto?", isBot: true),
      SpeakingMessage(en: "Es correcto. ¿El desayuno está incluido en mi estancia?", pt: "Está correto. O café da manhã está incluso na minha estadia?", isBot: false),
      SpeakingMessage(en: "Sí, el desayuno se sirve de 7:00 a 10:00 en el restaurante principal. Aquí tiene sus llaves.", pt: "Sim, o café da manhã é servido das sete às dez no restaurante principal. Aqui estão suas chaves.", isBot: true),
      SpeakingMessage(en: "Perfecto. ¿Dónde está el gimnasio y necesito algún código?", pt: "Perfeito. Onde a academia fica localizada e eu preciso de um código?", isBot: false),
      SpeakingMessage(en: "El gimnasio está en el segundo piso y puede acceder con la llave de su habitación.", pt: "La academia fica no segundo andar e você pode acessá-la com a chave do seu quarto.", isBot: true),
    ],
  ),

  // ==========================================
  // ADVANCED LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 3,
    title: "Entrevista de Emprego",
    description: "Discuta suas qualidades e experiências profissionais em espanhol.",
    level: SpeakingLevel.advanced,
    icon: Icons.work_rounded,
    messages: [
      SpeakingMessage(en: "Gracias por venir hoy. Para empezar, ¿puede hablarme un poco sobre su trayectoria?", pt: "Obrigado por vir hoje. Para começar, você poderia me contar um pouco sobre o seu histórico?", isBot: true),
      SpeakingMessage(en: "Trabajo como desarrollador de software desde hace cinco años, especializado en aplicaciones móviles.", pt: "Trabalho como desenvolvedor de software há cinco anos, me especializando em aplicativos móveis.", isBot: false),
      SpeakingMessage(en: "Es impresionante. ¿Puede describir un proyecto difícil que haya gestionado con éxito?", pt: "Isso parece impressionante. Você pode descrever um projeto desafiador que gerenciou com sucesso?", isBot: true),
      SpeakingMessage(en: "Recientemente lideré un equipo para rediseñar nuestra aplicação principal, reduciendo los tiempos de carga en un 40%.", pt: "Recentemente liderei uma equipe para redesenhar nosso aplicativo principal, reduzindo o tempo de carregamento em quarenta por cento.", isBot: false),
      SpeakingMessage(en: "Excelente. ¿Por qué cree que es la persona adecuada para este puesto?", pt: "Excelente. Por que você acredita que é a pessoa certa para esta posição em nossa empresa?", isBot: true),
      SpeakingMessage(en: "Aporto una sólida ética de trabajo, experiencia técnica y pasión por la creación de productos sencillos.", pt: "Trago uma forte ética de trabalho, experiência técnica e paixão por criar produtos fáceis de usar.", isBot: false),
    ],
  ),

  // ==========================================
  // NATIVE LEVEL
  // ==========================================
  const SpeakingScenario(
    id: 4,
    title: "Pedindo um Favor",
    description: "Use expressões naturais para pedir um grande favor a um amigo em espanhol.",
    level: SpeakingLevel.native,
    icon: Icons.handshake_rounded,
    messages: [
      SpeakingMessage(en: "Oye, ¿tienes un segundo? Realmente necesito hablar contigo sobre algo.", pt: "Ei cara, você tem um segundo? Eu realmente preciso falar uma coisa com você.", isBot: true),
      SpeakingMessage(en: "Claro, ¿qué pasa? Pareces un poco estresado, ¿está todo bien?", pt: "Claro, o que houve? Você parece um pouco estressado, está tudo bem?", isBot: false),
      SpeakingMessage(en: "Para ser sincero, estoy en una situación difícil. Mi coche se averió y tengo que llevar a mi hermana al aeropuerto.", pt: "Para falar a verdade, estou em apuros. Meu carro quebrou e preciso levar minha irmã ao aeroporto.", isBot: true),
      SpeakingMessage(en: "¡No te preocupes! Yo puedo llevarla. Nos conocemos desde hace mucho tiempo, así que no es problema.", pt: "Não se preocupe! Eu posso levá-la. Nós somos velhos amigos, então realmente não é grande coisa.", isBot: false),
      SpeakingMessage(en: "¡Oh gracias, me salvas la vida! Te la debo, de verdad.", pt: "Cara, você salvou minha vida! Te devo uma grande por causa disso, sério.", isBot: true),
      SpeakingMessage(en: "No te preocupes por eso. Simplemente devuélveme el favor la próxima vez que esté en apuros.", pt: "Nem esquenta com isso. Apenas retribua o favor na próxima vez que eu estiver em apuros.", isBot: false),
    ],
  ),

  // ==========================================
  // BASIC LEVEL (ADDITIONAL)
  // ==========================================
  const SpeakingScenario(
    id: 5,
    title: "Pedindo Direções",
    description: "Aprenda a pedir e entender direções simples na rua em espanhol.",
    level: SpeakingLevel.basic,
    icon: Icons.map_rounded,
    messages: [
      SpeakingMessage(en: "Disculpe, ¿sabe dónde está la estación de metro más cercana?", pt: "Com licença, você sabe onde fica a estação de metrô mais próxima?", isBot: true),
      SpeakingMessage(en: "Sí, vaya recto por dos cuadras y luego doble a la izquierda.", pt: "Sim, vá reto por duas quadras e depois vire à esquerda.", isBot: false),
      SpeakingMessage(en: "¡Gracias! ¿Está lejos de aquí o puedo ir a pie?", pt: "Obrigado! Fica longe daqui ou eu posso ir andando?", isBot: true),
      SpeakingMessage(en: "Está muy cerca. Solo se tardan cinco minutos a pie para llegar.", pt: "É muito perto. Leva apenas os cinco minutos para ir andando até lá.", isBot: false),
      SpeakingMessage(en: "¡Perfecto, muchas gracias por su ajuda! ¡Buen día!", pt: "Perfeito, muito obrigado pela sua ajuda! Tenha um ótimo dia!", isBot: true),
      SpeakingMessage(en: "De nada. ¡Buen viaje!", pt: "De nada. Tenha uma boa viagem!", isBot: false),
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
      SpeakingMessage(en: "Buenos días. ¿Cuál parece ser el problema hoy?", pt: "Bom dia. Qual parece ser o problema hoje?", isBot: true),
      SpeakingMessage(en: "Tengo un dolor de cabeza fuerte y dolor de garganta desde ayer.", pt: "Estou com uma forte dor de cabeça e dor de garganta desde ontem.", isBot: false),
      SpeakingMessage(en: "¿Tiene también fiebre o tos?", pt: "Você também tem febre ou tosse?", isBot: true),
      SpeakingMessage(en: "Tuve una fiebre leve anoche, pero no tengo tos.", pt: "Tive uma febre leve ontem à noite, mas sem tosse.", isBot: false),
      SpeakingMessage(en: "Entiendo. Le voy a recetar algunos medicamentos. Descanse y beba mucha agua.", pt: "Entendo. Vou receitar alguns remédios. Descanse e beba bastante água.", isBot: true),
      SpeakingMessage(en: "Gracias, doctor. ¿Con qué frecuencia debo tomar el medicamento?", pt: "Obrigado, doutor. Com que frequência devo tomar o remédio?", isBot: false),
      SpeakingMessage(en: "Tome una tableta cada ocho horas después de las comidas.", pt: "Tome um comprimido a cada oito horas após as refeições.", isBot: true),
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
      SpeakingMessage(en: "Hola, gracias por visitar el apartamento. ¿Qué piensa del contrato de alquiler?", pt: "Olá, obrigado por visitar o apartamento. O que você acha do contrato de aluguel?", isBot: true),
      SpeakingMessage(en: "El apartamento es excelente, mas el alquiler mensual supera un poco mi presupuesto.", pt: "O apartamento é ótimo, mas o aluguel mensal está um pouco acima do meu orçamento.", isBot: false),
      SpeakingMessage(en: "Entiendo, pero incluye agua y estacionamiento privado. ¿En qué precio estaba pensando?", pt: "Eu entendo, mas inclui água e uma vaga de estacionamento privativa. Que preço você tinha em mente?", isBot: true),
      SpeakingMessage(en: "¿Consideraría un descuento del 5% si firmo un contrato de dos años?", pt: "Você consideraria um desconto de cinco por cento se eu assinar um contrato de dois anos?", isBot: false),
      SpeakingMessage(en: "Eso parece razonable. Si firma por dos años, puedo bajar el precio.", pt: "Isso parece razoável. Si você assinar por dois anos, posso baixar o preço.", isBot: true),
      SpeakingMessage(en: "Excelente. ¿Podemos actualizar el contrato y firmarlo el próximo lunes?", pt: "Excelente. Podemos atualizar o contrato e assiná-lo na próxima segunda-feira?", isBot: false),
      SpeakingMessage(en: "Sí, prepararé el contrato de arrendamiento revisado y se lo enviaré por correo electrónico mañana.", pt: "Sim, vou preparar o contrato revisado e enviar por e-mail para você amanhã.", isBot: true),
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
      SpeakingMessage(en: "¡Cuánto tiempo sin vernos! Tienes que contármelo todo sobre tu fin de semana.", pt: "Há quanto tempo! Você tem que me contar tudo sobre a sua viagem de fim de semana.", isBot: true),
      SpeakingMessage(en: "¡Ah, fue genial! Fuimos a la playa y nos relajamos todo el tiempo.", pt: "Ah, foi sensacional! Nós fomos para a praia e apenas relaxamos o tempo todo.", isBot: false),
      SpeakingMessage(en: "¡No me lo puedo creer! Qué envidia. ¿Probaron el nuevo restaurante de mariscos cerca del muelle?", pt: "Não brinca! Que inveja. Vocês foram àquele novo restaurante de frutos do mar perto do píer?", isBot: true),
      SpeakingMessage(en: "¡Sí! Era un poco caro, pero la comida estuvo increíble.", pt: "Sim, nós fomos! Foi um pouco caro, mas a comida estava fora desse mundo.", isBot: false),
      SpeakingMessage(en: "Excelente. Hace tiempo que quiero ir. Deberíamos vernos pronto y planear algo juntos.", pt: "Incrível. Estou querendo ir lá faz tempo. Vamos nos encontrar logo e planejar uma juntos.", isBot: true),
      SpeakingMessage(en: "¡Totalmente! Nos llamamos la próxima semana para cuadrar los detalles.", pt: "Com certeza! Vamos nos falar na próxima semana e acertar os detalhes.", isBot: false),
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
      SpeakingMessage(en: "¡Hola! ¿Cómo le puedo ayudar hoy?", pt: "Olá! Como posso te ajudar hoje?", isBot: true),
      SpeakingMessage(en: "Me gustaría un billete para Londres, por favor.", pt: "Eu gostaria de uma passagem para Londres, por favor.", isBot: false),
      SpeakingMessage(en: "¿Solo ida o ida y vuelta? ¿Y para qué hora?", pt: "Passagem de ida ou ida e volta? E para qual horário?", isBot: true),
      SpeakingMessage(en: "Solo ida para el próximo tren, por favor.", pt: "Uma passagem de ida para o próximo trem, por favor.", isBot: false),
      SpeakingMessage(en: "El próximo tren sale a las diez. Serán quince dólares.", pt: "O próximo trem sai às dez. Fica em quinze dólares.", isBot: true),
      SpeakingMessage(en: "Aquí tiene el dinero. ¿En qué andén es?", pt: "Aqui está o dinheiro. Qual é a plataforma?", isBot: false),
      SpeakingMessage(en: "Es el andén número cuatro. ¡Buen viaje!", pt: "É a plataforma quatro. Tenha uma boa viagem!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 10,
    title: "Apresentando-se",
    description: "Pratique falar seu nome, de onde você é e sua idade.",
    level: SpeakingLevel.basic,
    icon: Icons.person_pin_rounded,
    messages: [
      SpeakingMessage(en: "¡Hola! Yo soy Sarah. ¿Cuál es tu nombre?", pt: "Olá! Eu sou a Sarah. Qual é o seu nome?", isBot: true),
      SpeakingMessage(en: "¡Hola Sarah! Me llamo Lucas. Encantado de conocerte.", pt: "Olá Sarah! Meu nome é Lucas. Prazer em te conhecer.", isBot: false),
      SpeakingMessage(en: "Encantada de conocerte también, Lucas. ¿De dónde eres?", pt: "Prazer em te conhecer também, Lucas. De onde você é?", isBot: true),
      SpeakingMessage(en: "Soy de Brasil, pero ahora vivo en Nueva York.", pt: "Eu sou do Brasil, mas moro em Nova York agora.", isBot: false),
      SpeakingMessage(en: "¡Oh, es genial! ¿Cuántos años tienes, si se puede preguntar?", pt: "Ah, isso é ótimo! Quantos anos você tem, se me permite perguntar?", isBot: true),
      SpeakingMessage(en: "Tengo veinticinco años. ¿Y tú?", pt: "Eu tenho vinte e de cinco anos. E você?", isBot: false),
      SpeakingMessage(en: "Tengo veintiocho años. ¡Espero que pases un buen rato aquí!", pt: "Eu tenho vinte e oito. Espero que você aproveite seu tempo aqui!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 11,
    title: "No Supermercado",
    description: "Aprenda a pedir preços e encontrar itens na mercearia.",
    level: SpeakingLevel.basic,
    icon: Icons.shopping_cart_rounded,
    messages: [
      SpeakingMessage(en: "Disculpe, señor. ¿Necesita ayuda para encontrar algo?", pt: "Com licença, senhor. Precisa de ajuda para encontrar algo?", isBot: true),
      SpeakingMessage(en: "Sí, por favor. ¿Dónde puedo encontrar la leche fresca?", pt: "Sim, por favor. Onde posso encontrar o leite fresco?", isBot: false),
      SpeakingMessage(en: "Está en el pasillo tres, al lado del queso.", pt: "Fica no corredor três, ao lado do queijo.", isBot: true),
      SpeakingMessage(en: "Gracias. ¿Y cuánto cuesta esta bolsa de manzanas?", pt: "Obrigado. E quanto custa um saco de maçãs?", isBot: false),
      SpeakingMessage(en: "Están a cuatro dólares el kilo hoy.", pt: "Estão quatro dólares o quilo hoje.", isBot: true),
      SpeakingMessage(en: "Genial, me llevaré un kilo. ¿Dónde está la caja?", pt: "Ótimo, vou levar um quilo. Onde fica o caixa?", isBot: false),
      SpeakingMessage(en: "Las cajas están a la entrada de la tienda.", pt: "Os caixas ficam na frente da loja.", isBot: true),
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
      SpeakingMessage(en: "Gracias por llamar a Pizza Palace. ¿Desea hacer un pedido?", pt: "Obrigado por ligar para o Pizza Palace. Gostaria de fazer um pedido?", isBot: true),
      SpeakingMessage(en: "Sí, me gustaría una pizza grande de pepperoni y una botella de refresco.", pt: "Sim, eu gostaria de uma pizza grande de pepperoni e uma garrafa de refrigerante.", isBot: false),
      SpeakingMessage(en: "Claro. ¿Es para llevar o para entrega a domicilio?", pt: "Claro. É para retirar ou entrega na sua casa?", isBot: true),
      SpeakingMessage(en: "Es para entrega en la calle Principal número doce.", pt: "É para entrega na rua principal, casa número doze.", isBot: false),
      SpeakingMessage(en: "Perfecto. El total es veinticinco dólares. ¿Cómo va a pagar?", pt: "Perfeito. O total fica em vinte e cinco dólares. Como irá pagar?", isBot: true),
      SpeakingMessage(en: "Pagaré en efectivo a la entrega. ¿Cuánto tiempo tardará?", pt: "Vou pagar com dinheiro na entrega. Quanto tempo vai levar?", isBot: false),
      SpeakingMessage(en: "Debería llegar en unos treinta o cuarenta minutos. ¡Gracias!", pt: "Deve chegar em cerca de trinta a quarenta minutos. Obrigado!", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 13,
    title: "Relatando um Item Perdido",
    description: "Descreva uma bolsa perdida para a segurança do aeroporto ou equipe do hotel.",
    level: SpeakingLevel.intermediate,
    icon: Icons.find_in_page_rounded,
    messages: [
      SpeakingMessage(en: "Oficina de objetos perdidos. ¿Cómo le puedo ayudar hoy?", pt: "Departamento de Achados e Perdidos. Como posso te ajudar hoje?", isBot: true),
      SpeakingMessage(en: "Creo que dejé mi mochila en el vuelo procedente de Miami.", pt: "Acho que deixei minha mochila no voo vindo de Miami.", isBot: false),
      SpeakingMessage(en: "¿Puede describir la mochila y darme su número de vuelo?", pt: "Você pode descrever a mochila e me dizer o número do seu voo?", isBot: true),
      SpeakingMessage(en: "Es una mochila de cuero negro con dos grandes bolsillos laterales.", pt: "É uma mochila de couro preta com dois bolsos laterais grandes.", isBot: false),
      SpeakingMessage(en: "¿Y tenía alguna etiqueta con su nombre o identificación?", pt: "E ela tinha alguma etiqueta de nome ou identificação?", isBot: true),
      SpeakingMessage(en: "Sí, tiene una pequeña etiqueta azul com mi nombre, John Doe.", pt: "Sim, há uma pequena etiqueta azul com meu nome, John Doe.", isBot: false),
      SpeakingMessage(en: "De acuerdo. Comprobaremos la cabina y nos pondremos en contacto con usted si la encontramos.", pt: "Tudo bem. Vamos verificar a cabine e entraremos em contato se a encontrarmos.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 14,
    title: "Pedindo Recomendações",
    description: "Pergunte a um morador local por recomendações turísticas e lugares para jantar.",
    level: SpeakingLevel.intermediate,
    icon: Icons.recommend_rounded,
    messages: [
      SpeakingMessage(en: "¡Bienvenido a nuestro centro de visitantes! ¿Busca algo en particular?", pt: "Bem-vindo ao nosso centro de visitantes! Está procurando por algo específico?", isBot: true),
      SpeakingMessage(en: "Tengo dos días aquí. ¿Cuáles son los mejores lugares para visitar?", pt: "Tenho dois dias aqui. Quais são os melhores pontos turísticos para ver?", isBot: false),
      SpeakingMessage(en: "Debería visitar el castillo histórico y dar un paseo en barco.", pt: "Você deve visitar o castelo histórico e fazer um passeio de barco.", isBot: true),
      SpeakingMessage(en: "Suena divertido. ¿Conoce algún buen restaurante local cerca?", pt: "Isso parece divertido. Você conhece um bom restaurante local por perto?", isBot: false),
      SpeakingMessage(en: "El Seafood Grill cerca del puerto sirve excelentes platos locales.", pt: "O Seafood Grill perto do porto serve excelentes pratos locais.", isBot: true),
      SpeakingMessage(en: "¿Tengo que reservar para cenar allí?", pt: "Eu preciso fazer uma reserva para o jantar lá?", isBot: false),
      SpeakingMessage(en: "Se llena mucho los fines de semana, por lo que le recomiendo llamar con antelación.", pt: "Fica movimentado nos fins de semana, então recomendo ligar com antecedência.", isBot: true),
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
      SpeakingMessage(en: "Gracias por su asistencia. Discutamos el cronograma del proyecto para el próximo trimestre.", pt: "Obrigado por participar. Vamos discutir o cronograma do projeto para o próximo trimestre.", isBot: true),
      SpeakingMessage(en: "Tenemos que ajustar la fecha límite porque el diseño se ha retrasado.", pt: "Precisamos ajustar o prazo porque o design está atrasado.", isBot: false),
      SpeakingMessage(en: "¿Cuánto tempo adicional necesita el equipo de diseño para finalizar?", pt: "De quanto tempo extra a equipe de design precisa para finalizar o layout?", isBot: true),
      SpeakingMessage(en: "Pidieron otra semana para terminar la revisión final de los prototipos.", pt: "Eles pediram mais uma semana para concluir a revisão final dos protótipos.", isBot: false),
      SpeakingMessage(en: "Puedo extender la fecha límite, pero debemos lanzar antes de las vacaciones.", pt: "Posso estender o prazo, mas devemos lançar antes do feriado.", isBot: true),
      SpeakingMessage(en: "De acuerdo. Coordinaré con desarrollo para acelerar la programación.", pt: "Acordado. Vou coordenar com o desenvolvimento para acelerar a programação.", isBot: false),
      SpeakingMessage(en: "Excelente. Reunámonos de nuevo el jueves para revisar el nuevo cronograma.", pt: "Excelente. Vamos nos reunir novamente na quinta-feira para checar o novo cronograma.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 16,
    title: "Abrindo uma Conta Bancária",
    description: "Pergunte sobre taxas de juros, taxas mensais e cartões de crédito.",
    level: SpeakingLevel.advanced,
    icon: Icons.account_balance_rounded,
    messages: [
      SpeakingMessage(en: "Buenos días. ¿Cómo le puedo ayudar a abrir una cuenta hoy?", pt: "Bom dia. Como posso ajudá-lo a abrir uma conta hoje?", isBot: true),
      SpeakingMessage(en: "Me gustaría abrir una cuenta corriente con comisiones mensuales bajas.", pt: "Gostaria de abrir uma conta corrente com baixas taxas mensais.", isBot: false),
      SpeakingMessage(en: "Tenemos una cuenta básica sin comisiones si mantiene un saldo mínimo.", pt: "Temos uma conta básica sem taxas se você mantiver um saldo mínimo.", isBot: true),
      SpeakingMessage(en: "¿Cuál es el saldo mínimo requerido para evitar la comisión mensual?", pt: "Qual é o saldo mínimo exigido para isentar a taxa mensal?", isBot: false),
      SpeakingMessage(en: "Son mil dólares. ¿Se adapta a su presupuesto?", pt: "É de mil dólares. Isso funciona para o seu orçamento?", isBot: true),
      SpeakingMessage(en: "Sí, está bien. ¿Esta cuenta incluye una tarjeta de crédito?", pt: "Sim, está ótimo. Esta conta inclui um cartão de crédito?", isBot: false),
      SpeakingMessage(en: "Podemos solicitar una, sujeta a verificación y aprobación de crédito.", pt: "Podemos solicitar um, sujeito a uma verificação e aprovação de crédito.", isBot: true),
    ],
  ),
  const SpeakingScenario(
    id: 17,
    title: "Problemas com Aluguel de Carro",
    description: "Negocie reparos ou reclame sobre um carro alugado danificado.",
    level: SpeakingLevel.advanced,
    icon: Icons.car_rental_rounded,
    messages: [
      SpeakingMessage(en: "Bienvenido de vuelta. ¿Tuvo algún problema con el vehículo?", pt: "Bem-vindo de volta. Você teve algum problema com o veículo?", isBot: true),
      SpeakingMessage(en: "Sí, el aire acondicionado dejó de funcionar el segundo día.", pt: "Sim, o ar condicionado parou de funcionar no segundo dia.", isBot: false),
      SpeakingMessage(en: "Le pido disculpas por las molestias. ¿Lo reportó durante el alquiler?", pt: "Peço desculpas pelo inconveniente. Você relatou isso durante o aluguel?", isBot: true),
      SpeakingMessage(en: "Intenté llamar, pero su línea de atención al cliente estaba completamente saturada.", pt: "Tentei ligar, mas a sua linha de atendimento ao cliente estava totalmente ocupada.", isBot: false),
      SpeakingMessage(en: "Entiendo. Puedo ofrecerle un descuento del 20% en su factura total.", pt: "Eu entendo. Posso oferecer um desconto de vinte por cento na sua fatura total.", isBot: true),
      SpeakingMessage(en: "Agradezco la oferta, pero espero un reembolso completo por esos días.", pt: "Agradeço a oferta, mas espero um reembolso total por esses dias.", isBot: false),
      SpeakingMessage(en: "Déjeme consultar con mi gerente si podemos procesar un reembolso mayor.", pt: "Deixe-me verificar com meu gerente se podemos processar um reembolso maior.", isBot: true),
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
      SpeakingMessage(en: "Estaba pensando que podríamos organizar el evento al aire libre este año.", pt: "Estava pensando que poderíamos sediar o evento ao ar livre este ano.", isBot: true),
      SpeakingMessage(en: "No sé, es un poco arriesgado con el clima de la primavera.", pt: "Não sei, isso é um pouco arriscado com o tempo da primavera.", isBot: false),
      SpeakingMessage(en: "Es justo, pero nos ahorraría mucho dinero en el alquiler del local.", pt: "Justo, mas nos economizaria um bom dinheiro nas taxas do local.", isBot: true),
      SpeakingMessage(en: "Es verdad, pero si llueve, volveremos al punto de partida sin nada.", pt: "Verdade, mas se chover, voltaremos à estaca zero sem nada.", isBot: false),
      SpeakingMessage(en: "Es cierto. ¿Y si alquilamos una carpa como plan de respaldo?", pt: "Point taken. What if we rent a tent as a backup plan?", isBot: true),
      SpeakingMessage(en: "De acuerdo. Lleguemos a un acuerdo y reservemos un lugar semicubierto.", pt: "Isso funciona. Vamos chegar a um meio-termo e reservar um local semi-coberto.", isBot: false),
    ],
  ),
  const SpeakingScenario(
    id: 19,
    title: "Reclamando do Tempo",
    description: "Converse como um falante nativo sobre o tempo ruim inesperado.",
    level: SpeakingLevel.native,
    icon: Icons.cloudy_snowing,
    messages: [
      SpeakingMessage(en: "¿Viste este clima? ¡Está lloviendo a cántaros afuera!", pt: "Dá para acreditar nesse tempo? Está chovendo canivete lá fora!", isBot: true),
      SpeakingMessage(en: "¡Ya lo creo! Mi paraguas se volteó por completo.", pt: "Nem me fale! Meu guarda-chuva virou completamente do avesso.", isBot: false),
      SpeakingMessage(en: "¡El mío também! Quedé completamente empapado solo de caminar desde el coche.", pt: "O meu também! Fiquei totalmente encharcado só de andar do carro até aqui.", isBot: true),
      SpeakingMessage(en: "Y lo peor es que el pronóstico dice que va a durar toda la semana.", pt: "E a pior parte é que a previsão diz que vai durar a semana toda.", isBot: false),
      SpeakingMessage(en: "¡Oh no, es una broma! Esperaba tener un poco de sol.", pt: "Ah, você só pode estar brincando comigo. Eu estava esperando um pouco de sol.", isBot: true),
      SpeakingMessage(en: "Sin suerte, al parecer. Estamos atrapados adentro para el fin de semana.", pt: "Sem sorte, pelo jeito. Estamos presos dentro de casa no fim de semana.", isBot: false),
    ],
  ),
  const SpeakingScenario(
    id: 20,
    title: "Conversando sobre um Filme",
    description: "Discuta reviravoltas na história e avalie um filme usando expressões cotidianas.",
    level: SpeakingLevel.native,
    icon: Icons.movie_rounded,
    messages: [
      SpeakingMessage(en: "¿Así que finalmente viste ese thriller del que todo el mundo habla?", pt: "E aí, você finalmente assistiu àquele suspense de que todo mundo está falando?", isBot: true),
      SpeakingMessage(en: "Sí, lo vi anoche. ¡El giro de la trama me dejó boquiabierto!", pt: "Sim, assisti ontem à noite. A reviravolta na história explodiu minha cabeça!", isBot: false),
      SpeakingMessage(en: "¿Verdad? ¡No me lo esperaba para nada! Me mantuvo en vilo todo el tempo.", pt: "Né? Eu não esperava por aquilo de jeito nenhum! Me manteve na beira da cadeira.", isBot: true),
      SpeakingMessage(en: "Exactamente. El actor principal realmente la rompió con su actuación.", pt: "Exatamente. O ator principal realmente arrebentou com a atuação dele.", isBot: false),
      SpeakingMessage(en: "Sin duda. Pero el final pareció un poco apresurado, ¿no crees?", pt: "Ele arrebentou mesmo. Mas o final pareceu um pouco apressado, você não acha?", isBot: true),
      SpeakingMessage(en: "Un poco, sí. En general, sin embargo, valió la pena por completo.", pt: "Um pouco, sim. No geral, no entanto, valeu cada centavo.", isBot: false),
    ],
  ),
];
