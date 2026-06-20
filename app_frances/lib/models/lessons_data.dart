class LessonItem {
  final String questionEn; // Keep variable name to avoid refactoring models/UI
  final String answerPt;
  final List<String> optionsPt;

  const LessonItem({
    required this.questionEn,
    required this.answerPt,
    required this.optionsPt,
  });
}

class Lesson {
  final String id;
  final String title;
  final String level;
  final String description;
  final List<LessonItem> items;
  int progress; // How many items completed (0 to items.length)
  bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.level,
    required this.description,
    required this.items,
    this.progress = 0,
    this.isCompleted = false,
  });
}

// Global mock state for lessons in French.
final List<Lesson> appLessons = [
  Lesson(
    id: "l1",
    title: "Lição 1: O Básico",
    level: "Fácil",
    description: "Cumprimentos e palavras essenciais do dia a dia em francês.",
    items: const [
      LessonItem(questionEn: "Bonjour", answerPt: "Olá", optionsPt: ["Obrigado", "Olá", "Adeus", "Sim"]),
      LessonItem(questionEn: "Bonjour (Matin)", answerPt: "Bom dia", optionsPt: ["Boa noite", "Bom dia", "Com licença", "Não"]),
      LessonItem(questionEn: "Merci", answerPt: "Obrigado", optionsPt: ["Obrigado", "Desculpe", "Por favor", "De nada"]),
      LessonItem(questionEn: "Oui", answerPt: "Sim", optionsPt: ["Não", "Sim", "Talvez", "Sempre"]),
      LessonItem(questionEn: "Au revoir", answerPt: "Adeus", optionsPt: ["Bem vindo", "Bom dia", "Adeus", "Oi"]),
      LessonItem(questionEn: "S'il vous plaît", answerPt: "Por favor", optionsPt: ["Por favor", "De nada", "Oi", "Desculpe"]),
      LessonItem(questionEn: "Désolé", answerPt: "Desculpe", optionsPt: ["Perdão", "Bom dia", "Desculpe", "Nada"]),
      LessonItem(questionEn: "Bonne nuit", answerPt: "Boa noite", optionsPt: ["Bom dia", "Boa tarde", "Boa noite", "Até logo"]),
      LessonItem(questionEn: "De rien", answerPt: "De nada", optionsPt: ["Por favor", "De nada", "Sim", "Até amanhã"]),
      LessonItem(questionEn: "Salut", answerPt: "Oi", optionsPt: ["Olá", "Oi", "Tchau", "Certo"]),
    ],
  ),
  Lesson(
    id: "l2",
    title: "Lição 2: Números",
    level: "Fácil",
    description: "Aprenda a contar de 1 a 10 em francês.",
    items: const [
      LessonItem(questionEn: "Un", answerPt: "Um", optionsPt: ["Dois", "Três", "Um", "Dez"]),
      LessonItem(questionEn: "Deux", answerPt: "Dois", optionsPt: ["Quatro", "Dez", "Dois", "Um"]),
      LessonItem(questionEn: "Trois", answerPt: "Três", optionsPt: ["Três", "Oito", "Seis", "Nove"]),
      LessonItem(questionEn: "Quatre", answerPt: "Quatro", optionsPt: ["Cinco", "Quatro", "Onze", "Três"]),
      LessonItem(questionEn: "Cinq", answerPt: "Cinco", optionsPt: ["Dez", "Oito", "Dois", "Cinco"]),
      LessonItem(questionEn: "Six", answerPt: "Seis", optionsPt: ["Sete", "Seis", "Quatro", "Três"]),
      LessonItem(questionEn: "Sept", answerPt: "Sete", optionsPt: ["Nove", "Sete", "Oito", "Dois"]),
      LessonItem(questionEn: "Huit", answerPt: "Oito", optionsPt: ["Oito", "Um", "Dez", "Sete"]),
      LessonItem(questionEn: "Neuf", answerPt: "Nove", optionsPt: ["Dez", "Cinco", "Dois", "Nove"]),
      LessonItem(questionEn: "Dix", answerPt: "Dez", optionsPt: ["Um", "Três", "Dez", "Sete"]),
    ],
  ),
  Lesson(
    id: "l3",
    title: "Lição 3: Cores",
    level: "Fácil",
    description: "Cores fundamentais em francês.",
    items: const [
      LessonItem(questionEn: "Rouge", answerPt: "Vermelho", optionsPt: ["Azul", "Vermelho", "Verde", "Amarelo"]),
      LessonItem(questionEn: "Bleu", answerPt: "Azul", optionsPt: ["Amarelo", "Violeta", "Azul", "Preto"]),
      LessonItem(questionEn: "Vert", answerPt: "Verde", optionsPt: ["Verde", "Rosa", "Cinza", "Branco"]),
      LessonItem(questionEn: "Jaune", answerPt: "Amarelo", optionsPt: ["Preto", "Rosa", "Laranja", "Amarelo"]),
      LessonItem(questionEn: "Noir", answerPt: "Preto", optionsPt: ["Preto", "Turquesa", "Marrom", "Azul"]),
      LessonItem(questionEn: "Blanc", answerPt: "Branco", optionsPt: ["Lilás", "Cinza", "Verde", "Branco"]),
      LessonItem(questionEn: "Orange", answerPt: "Laranja", optionsPt: ["Vermelho", "Laranja", "Preto", "Bordô"]),
      LessonItem(questionEn: "Rose", answerPt: "Rosa", optionsPt: ["Rosa", "Azul", "Lilás", "Amarelo"]),
      LessonItem(questionEn: "Marron", answerPt: "Marrom", optionsPt: ["Verde", "Marrom", "Cinza", "Preto"]),
      LessonItem(questionEn: "Gris", answerPt: "Cinza", optionsPt: ["Amarelo", "Cinza", "Branco", "Rosa"]),
    ],
  ),
  Lesson(
    id: "l4",
    title: "Lição 4: Família",
    level: "Fácil",
    description: "Membros da família e relacionamentos em francês.",
    items: const [
      LessonItem(questionEn: "Mère", answerPt: "Mãe", optionsPt: ["Tia", "Mãe", "Prima", "Avó"]),
      LessonItem(questionEn: "Père", answerPt: "Pai", optionsPt: ["Pai", "Tio", "Avô", "Irmão"]),
      LessonItem(questionEn: "Frère", answerPt: "Irmão", optionsPt: ["Primo", "Tio", "Irmão", "Avô"]),
      LessonItem(questionEn: "Sœur", answerPt: "Irmã", optionsPt: ["Irmã", "Mãe", "Amiga", "Tia"]),
      LessonItem(questionEn: "Grand-mère", answerPt: "Avó", optionsPt: ["Avó", "Mãe", "Sobrinha", "Tia"]),
      LessonItem(questionEn: "Grand-père", answerPt: "Avô", optionsPt: ["Pai", "Tio", "Neto", "Avô"]),
      LessonItem(questionEn: "Oncle", answerPt: "Tio", optionsPt: ["Primo", "Tio", "Avô", "Amigo"]),
      LessonItem(questionEn: "Tante", answerPt: "Tia", optionsPt: ["Tia", "Avó", "Cunhada", "Irmã"]),
      LessonItem(questionEn: "Cousin / Cousine", answerPt: "Primo/Prima", optionsPt: ["Amigo", "Filho", "Primo/Prima", "Neto"]),
      LessonItem(questionEn: "Fils", answerPt: "Filho", optionsPt: ["Irmão", "Filho", "Sobrinho", "Neto"]),
    ],
  ),
  Lesson(
    id: "l5",
    title: "Lição 5: Animais",
    level: "Fácil",
    description: "Animais domésticos e selvagens em francês.",
    items: const [
      LessonItem(questionEn: "Chien", answerPt: "Cachorro", optionsPt: ["Gato", "Pássaro", "Cachorro", "Peixe"]),
      LessonItem(questionEn: "Chat", answerPt: "Gato", optionsPt: ["Gato", "Sapo", "Coelho", "Cachorro"]),
      LessonItem(questionEn: "Oiseau", answerPt: "Pássaro", optionsPt: ["Galinha", "Pássaro", "Vaca", "Pato"]),
      LessonItem(questionEn: "Poisson", answerPt: "Peixe", optionsPt: ["Peixe", "Sapo", "Cobra", "Baleia"]),
      LessonItem(questionEn: "Cheval", answerPt: "Cavalo", optionsPt: ["Ovelha", "Cavalo", "Boi", "Porco"]),
      LessonItem(questionEn: "Vache", answerPt: "Vaca", optionsPt: ["Vaca", "Tartaruga", "Cavalo", "Ovelha"]),
      LessonItem(questionEn: "Singe", answerPt: "Macaco", optionsPt: ["Leão", "Macaco", "Urso", "Zebra"]),
      LessonItem(questionEn: "Lion", answerPt: "Leão", optionsPt: ["Tigre", "Elefante", "Leão", "Jacaré"]),
      LessonItem(questionEn: "Éléphant", answerPt: "Elefante", optionsPt: ["Girafa", "Zebra", "Elefante", "Panda"]),
      LessonItem(questionEn: "Ours", answerPt: "Urso", optionsPt: ["Lobo", "Raposa", "Leão", "Urso"]),
    ],
  ),
  Lesson(
    id: "l6",
    title: "Lição 6: Alimentos",
    level: "Pré-Intermediário",
    description: "Comidas e bebidas em francês.",
    items: const [
      LessonItem(questionEn: "Eau", answerPt: "Água", optionsPt: ["Suco", "Água", "Leite", "Café"]),
      LessonItem(questionEn: "Pain", answerPt: "Pão", optionsPt: ["Pão", "Bolo", "Queijo", "Manteiga"]),
      LessonItem(questionEn: "Fromage", answerPt: "Queijo", optionsPt: ["Ovo", "Presunto", "Queijo", "Carne"]),
      LessonItem(questionEn: "Viande", answerPt: "Carne", optionsPt: ["Frango", "Peixe", "Fruta", "Carne"]),
      LessonItem(questionEn: "Poulet", answerPt: "Frango", optionsPt: ["Boi", "Porco", "Frango", "Ovelha"]),
      LessonItem(questionEn: "Pomme", answerPt: "Maçã", optionsPt: ["Banana", "Maçã", "Uva", "Pera"]),
      LessonItem(questionEn: "Café", answerPt: "Café", optionsPt: ["Café", "Chá", "Água", "Refrigerante"]),
      LessonItem(questionEn: "Thé", answerPt: "Chá", optionsPt: ["Cerveja", "Café", "Chá", "Suco"]),
      LessonItem(questionEn: "Lait", answerPt: "Leite", optionsPt: ["Água", "Iogurte", "Leite", "Queijo"]),
      LessonItem(questionEn: "Riz", answerPt: "Arroz", optionsPt: ["Feijão", "Arroz", "Trigo", "Pão"]),
    ],
  ),
  Lesson(
    id: "l7",
    title: "Lição 7: Viagem",
    level: "Pré-Intermediário",
    description: "Vocabulário sobre passagens, aeroportos e hotéis em francês.",
    items: const [
      LessonItem(questionEn: "Billet", answerPt: "Passagem/Bilhete", optionsPt: ["Mala", "Passagem/Bilhete", "Passaporte", "Hotel"]),
      LessonItem(questionEn: "Aéroport", answerPt: "Aeroporto", optionsPt: ["Aeroporto", "Estação", "Porto", "Ponto de ônibus"]),
      LessonItem(questionEn: "Bagage", answerPt: "Bagagem", optionsPt: ["Bolsa", "Mochila", "Bagagem", "Carteira"]),
      LessonItem(questionEn: "Vol", answerPt: "Voo", optionsPt: ["Carro", "Navio", "Voo", "Avião"]),
      LessonItem(questionEn: "Hôtel", answerPt: "Hotel", optionsPt: ["Casa", "Quarto", "Hotel", "Fazenda"]),
      LessonItem(questionEn: "Passeport", answerPt: "Passaporte", optionsPt: ["Passaporte", "Identidade", "Visto", "Assinatura"]),
      LessonItem(questionEn: "Voyage", answerPt: "Viagem", optionsPt: ["Chegada", "Viagem", "Partida", "Encontro"]),
      LessonItem(questionEn: "Touriste", answerPt: "Turista", optionsPt: ["Guia", "Morador", "Estrangeiro", "Turista"]),
      LessonItem(questionEn: "Carte", answerPt: "Mapa", optionsPt: ["Revista", "Direção", "Mapa", "Jornal"]),
      LessonItem(questionEn: "Train", answerPt: "Trem", optionsPt: ["Ônibus", "Trem", "Metrô", "Moto"]),
    ],
  ),
  Lesson(
    id: "l8",
    title: "Lição 8: Na Cidade",
    level: "Intermediário",
    description: "Lugares e direções vitais em francês.",
    items: const [
      LessonItem(questionEn: "Hôpital", answerPt: "Hospital", optionsPt: ["Escola", "Clínica", "Hospital", "Farmácia"]),
      LessonItem(questionEn: "École", answerPt: "Escola", optionsPt: ["Escola", "Faculdade", "Igreja", "Loja"]),
      LessonItem(questionEn: "Rue", answerPt: "Rua", optionsPt: ["Rua", "Avenida", "Praça", "Ponte"]),
      LessonItem(questionEn: "Parc", answerPt: "Parque", optionsPt: ["Jardim", "Parque", "Rua", "Shopping"]),
      LessonItem(questionEn: "Banque", answerPt: "Banco", optionsPt: ["Supermercado", "Cofre", "Dinheiro", "Banco"]),
      LessonItem(questionEn: "Supermarché", answerPt: "Supermercado", optionsPt: ["Loja", "Mercado", "Supermercado", "Shopping"]),
      LessonItem(questionEn: "Restaurant", answerPt: "Restaurante", optionsPt: ["Café", "Restaurante", "Lanchonete", "Bar"]),
      LessonItem(questionEn: "Pharmacie", answerPt: "Farmácia", optionsPt: ["Clínica", "Loja", "Farmácia", "Hospital"]),
      LessonItem(questionEn: "Gauche", answerPt: "Esquerda", optionsPt: ["Esquerda", "Direita", "Frente", "Reto"]),
      LessonItem(questionEn: "Droite", answerPt: "Direita", optionsPt: ["Cima", "Trás", "Direita", "Baixo"]),
    ],
  ),
  Lesson(
    id: "l9",
    title: "Lição 9: Rotina e Ações",
    level: "Intermediário",
    description: "Verbos e ações comuns do cotidiano em francês.",
    items: const [
      LessonItem(questionEn: "Marcher", answerPt: "Andar", optionsPt: ["Correr", "Andar", "Pular", "Sentar"]),
      LessonItem(questionEn: "Manger", answerPt: "Comer", optionsPt: ["Beber", "Estudar", "Falar", "Comer"]),
      LessonItem(questionEn: "Dormir", answerPt: "Dormir", optionsPt: ["Acordar", "Sonhar", "Dormir", "Deitar"]),
      LessonItem(questionEn: "Étudier", answerPt: "Estudar", optionsPt: ["Ler", "Estudar", "Escrever", "Pensar"]),
      LessonItem(questionEn: "Travailler", answerPt: "Trabalhar", optionsPt: ["Divertir", "Trabalhar", "Descansar", "Focar"]),
      LessonItem(questionEn: "Parler", answerPt: "Falar", optionsPt: ["Falar", "Gritar", "Ouvir", "Cantar"]),
      LessonItem(questionEn: "Acheter", answerPt: "Comprar", optionsPt: ["Vender", "Levar", "Dar", "Comprar"]),
      LessonItem(questionEn: "Courir", answerPt: "Correr", optionsPt: ["Brincar", "Rastejar", "Correr", "Pular"]),
      LessonItem(questionEn: "Aller", answerPt: "Ir", optionsPt: ["Ficar", "Ir", "Chegar", "Voltar"]),
      LessonItem(questionEn: "Faire", answerPt: "Fazer", optionsPt: ["Fazer", "Construir", "Quebrar", "Lavar"]),
    ],
  ),
  Lesson(
    id: "l10",
    title: "Lição 10: Adjetivos Intermediários",
    level: "Intermediário",
    description: "Qualidades e sentimentos básicos em francês.",
    items: const [
      LessonItem(questionEn: "Heureux", answerPt: "Feliz", optionsPt: ["Triste", "Feliz", "Bravo", "Cansado"]),
      LessonItem(questionEn: "Triste", answerPt: "Triste", optionsPt: ["Zangado", "Solitário", "Triste", "Feliz"]),
      LessonItem(questionEn: "Fâché / En colère", answerPt: "Bravo/Zangado", optionsPt: ["Nervoso", "Chateado", "Bravo/Zangado", "Calmo"]),
      LessonItem(questionEn: "Fatigué", answerPt: "Cansado", optionsPt: ["Com fome", "Cansado", "Dormindo", "Doente"]),
      LessonItem(questionEn: "Beau / Belle", answerPt: "Bonito(a)", optionsPt: ["Feio", "Rápido", "Bonito(a)", "Novo"]),
      LessonItem(questionEn: "Laid / Moche", answerPt: "Feio(a)", optionsPt: ["Chato", "Feio(a)", "Bonito", "Velho"]),
      LessonItem(questionEn: "Rapide", answerPt: "Rápido", optionsPt: ["Devagar", "Rápido", "Lento", "Cedo"]),
      LessonItem(questionEn: "Lent", answerPt: "Lento/Devagar", optionsPt: ["Tranquilo", "Rápido", "Lento/Devagar", "Tarde"]),
      LessonItem(questionEn: "Nouveau", answerPt: "Novo", optionsPt: ["Velho", "Atual", "Jovem", "Novo"]),
      LessonItem(questionEn: "Vieux", answerPt: "Velho/Antigo", optionsPt: ["Senhor", "Limpo", "Velho/Antigo", "Usado"]),
    ],
  ),
];
