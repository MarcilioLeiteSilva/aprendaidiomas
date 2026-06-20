class LessonItem {
  final String questionEn;
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

// Global mock state for lessons. In a real app, progress/isCompleted would be saved in SQLite/SharedPreferences.
final List<Lesson> appLessons = [
  Lesson(
    id: "l1",
    title: "Lição 1: O Básico",
    level: "Fácil",
    description: "Cumprimentos e palavras essenciais do dia a dia.",
    items: const [
      LessonItem(questionEn: "Hello", answerPt: "Olá", optionsPt: ["Obrigado", "Olá", "Adeus", "Sim"]),
      LessonItem(questionEn: "Good morning", answerPt: "Bom dia", optionsPt: ["Boa noite", "Bom dia", "Com licença", "Não"]),
      LessonItem(questionEn: "Thank you", answerPt: "Obrigado", optionsPt: ["Obrigado", "Desculpe", "Por favor", "De nada"]),
      LessonItem(questionEn: "Yes", answerPt: "Sim", optionsPt: ["Não", "Sim", "Talvez", "Sempre"]),
      LessonItem(questionEn: "Goodbye", answerPt: "Adeus", optionsPt: ["Bem vindo", "Bom dia", "Adeus", "Oi"]),
      LessonItem(questionEn: "Please", answerPt: "Por favor", optionsPt: ["Por favor", "De nada", "Oi", "Desculpe"]),
      LessonItem(questionEn: "Sorry", answerPt: "Desculpe", optionsPt: ["Perdão", "Bom dia", "Desculpe", "Nada"]),
      LessonItem(questionEn: "Good night", answerPt: "Boa noite", optionsPt: ["Bom dia", "Boa tarde", "Boa noite", "Até logo"]),
      LessonItem(questionEn: "You are welcome", answerPt: "De nada", optionsPt: ["Por favor", "De nada", "Sim", "Até amanhã"]),
      LessonItem(questionEn: "Hi", answerPt: "Oi", optionsPt: ["Olá", "Oi", "Tchau", "Certo"]),
    ],
  ),
  Lesson(
    id: "l2",
    title: "Lição 2: Números",
    level: "Fácil",
    description: "Aprenda a contar de 1 a 10.",
    items: const [
      LessonItem(questionEn: "One", answerPt: "Um", optionsPt: ["Dois", "Três", "Um", "Dez"]),
      LessonItem(questionEn: "Two", answerPt: "Dois", optionsPt: ["Quatro", "Dez", "Dois", "Um"]),
      LessonItem(questionEn: "Three", answerPt: "Três", optionsPt: ["Três", "Oito", "Seis", "Nove"]),
      LessonItem(questionEn: "Four", answerPt: "Quatro", optionsPt: ["Cinco", "Quatro", "Onze", "Três"]),
      LessonItem(questionEn: "Five", answerPt: "Cinco", optionsPt: ["Dez", "Oito", "Dois", "Cinco"]),
      LessonItem(questionEn: "Six", answerPt: "Seis", optionsPt: ["Sete", "Seis", "Quatro", "Três"]),
      LessonItem(questionEn: "Seven", answerPt: "Sete", optionsPt: ["Nove", "Sete", "Oito", "Dois"]),
      LessonItem(questionEn: "Eight", answerPt: "Oito", optionsPt: ["Oito", "Um", "Dez", "Sete"]),
      LessonItem(questionEn: "Nine", answerPt: "Nove", optionsPt: ["Dez", "Cinco", "Dois", "Nove"]),
      LessonItem(questionEn: "Ten", answerPt: "Dez", optionsPt: ["Um", "Três", "Dez", "Sete"]),
    ],
  ),
  Lesson(
    id: "l3",
    title: "Lição 3: Cores",
    level: "Fácil",
    description: "Cores fundamentais.",
    items: const [
      LessonItem(questionEn: "Red", answerPt: "Vermelho", optionsPt: ["Azul", "Vermelho", "Verde", "Amarelo"]),
      LessonItem(questionEn: "Blue", answerPt: "Azul", optionsPt: ["Amarelo", "Violeta", "Azul", "Preto"]),
      LessonItem(questionEn: "Green", answerPt: "Verde", optionsPt: ["Verde", "Rosa", "Cinza", "Branco"]),
      LessonItem(questionEn: "Yellow", answerPt: "Amarelo", optionsPt: ["Preto", "Rosa", "Laranja", "Amarelo"]),
      LessonItem(questionEn: "Black", answerPt: "Preto", optionsPt: ["Preto", "Turquesa", "Marrom", "Azul"]),
      LessonItem(questionEn: "White", answerPt: "Branco", optionsPt: ["Lilás", "Cinza", "Verde", "Branco"]),
      LessonItem(questionEn: "Orange", answerPt: "Laranja", optionsPt: ["Vermelho", "Laranja", "Preto", "Bordô"]),
      LessonItem(questionEn: "Pink", answerPt: "Rosa", optionsPt: ["Rosa", "Azul", "Lilás", "Amarelo"]),
      LessonItem(questionEn: "Brown", answerPt: "Marrom", optionsPt: ["Verde", "Marrom", "Cinza", "Preto"]),
      LessonItem(questionEn: "Gray", answerPt: "Cinza", optionsPt: ["Amarelo", "Cinza", "Branco", "Rosa"]),
    ],
  ),
  Lesson(
    id: "l4",
    title: "Lição 4: Família",
    level: "Fácil",
    description: "Membros da família e relacionamentos.",
    items: const [
      LessonItem(questionEn: "Mother", answerPt: "Mãe", optionsPt: ["Tia", "Mãe", "Prima", "Avó"]),
      LessonItem(questionEn: "Father", answerPt: "Pai", optionsPt: ["Pai", "Tio", "Avô", "Irmão"]),
      LessonItem(questionEn: "Brother", answerPt: "Irmão", optionsPt: ["Primo", "Tio", "Irmão", "Avô"]),
      LessonItem(questionEn: "Sister", answerPt: "Irmã", optionsPt: ["Irmã", "Mãe", "Amiga", "Tia"]),
      LessonItem(questionEn: "Grandmother", answerPt: "Avó", optionsPt: ["Avó", "Mãe", "Sobrinha", "Tia"]),
      LessonItem(questionEn: "Grandfather", answerPt: "Avô", optionsPt: ["Pai", "Tio", "Neto", "Avô"]),
      LessonItem(questionEn: "Uncle", answerPt: "Tio", optionsPt: ["Primo", "Tio", "Avô", "Amigo"]),
      LessonItem(questionEn: "Aunt", answerPt: "Tia", optionsPt: ["Tia", "Avó", "Cunhada", "Irmã"]),
      LessonItem(questionEn: "Cousin", answerPt: "Primo/Prima", optionsPt: ["Amigo", "Filho", "Primo/Prima", "Neto"]),
      LessonItem(questionEn: "Son", answerPt: "Filho", optionsPt: ["Irmão", "Filho", "Sobrinho", "Neto"]),
    ],
  ),
  Lesson(
    id: "l5",
    title: "Lição 5: Animais",
    level: "Fácil",
    description: "Animais domésticos e selvagens.",
    items: const [
      LessonItem(questionEn: "Dog", answerPt: "Cachorro", optionsPt: ["Gato", "Pássaro", "Cachorro", "Peixe"]),
      LessonItem(questionEn: "Cat", answerPt: "Gato", optionsPt: ["Gato", "Sapo", "Coelho", "Cachorro"]),
      LessonItem(questionEn: "Bird", answerPt: "Pássaro", optionsPt: ["Galinha", "Pássaro", "Vaca", "Pato"]),
      LessonItem(questionEn: "Fish", answerPt: "Peixe", optionsPt: ["Peixe", "Sapo", "Cobra", "Baleia"]),
      LessonItem(questionEn: "Horse", answerPt: "Cavalo", optionsPt: ["Ovelha", "Cavalo", "Boi", "Porco"]),
      LessonItem(questionEn: "Cow", answerPt: "Vaca", optionsPt: ["Vaca", "Tartaruga", "Cavalo", "Ovelha"]),
      LessonItem(questionEn: "Monkey", answerPt: "Macaco", optionsPt: ["Leão", "Macaco", "Urso", "Zebra"]),
      LessonItem(questionEn: "Lion", answerPt: "Leão", optionsPt: ["Tigre", "Elefante", "Leão", "Jacaré"]),
      LessonItem(questionEn: "Elephant", answerPt: "Elefante", optionsPt: ["Girafa", "Zebra", "Elefante", "Panda"]),
      LessonItem(questionEn: "Bear", answerPt: "Urso", optionsPt: ["Lobo", "Raposa", "Leão", "Urso"]),
    ],
  ),
  Lesson(
    id: "l6",
    title: "Lição 6: Alimentos",
    level: "Pré-Intermediário",
    description: "Comidas e bebidas.",
    items: const [
      LessonItem(questionEn: "Water", answerPt: "Água", optionsPt: ["Suco", "Água", "Leite", "Café"]),
      LessonItem(questionEn: "Bread", answerPt: "Pão", optionsPt: ["Pão", "Bolo", "Queijo", "Manteiga"]),
      LessonItem(questionEn: "Cheese", answerPt: "Queijo", optionsPt: ["Ovo", "Presunto", "Queijo", "Carne"]),
      LessonItem(questionEn: "Meat", answerPt: "Carne", optionsPt: ["Frango", "Peixe", "Fruta", "Carne"]),
      LessonItem(questionEn: "Chicken", answerPt: "Frango", optionsPt: ["Boi", "Porco", "Frango", "Ovelha"]),
      LessonItem(questionEn: "Apple", answerPt: "Maçã", optionsPt: ["Banana", "Maçã", "Uva", "Pera"]),
      LessonItem(questionEn: "Coffee", answerPt: "Café", optionsPt: ["Café", "Chá", "Água", "Refrigerante"]),
      LessonItem(questionEn: "Tea", answerPt: "Chá", optionsPt: ["Cerveja", "Café", "Chá", "Suco"]),
      LessonItem(questionEn: "Milk", answerPt: "Leite", optionsPt: ["Água", "Iogurte", "Leite", "Queijo"]),
      LessonItem(questionEn: "Rice", answerPt: "Arroz", optionsPt: ["Feijão", "Arroz", "Trigo", "Pão"]),
    ],
  ),
  Lesson(
    id: "l7",
    title: "Lição 7: Viagem",
    level: "Pré-Intermediário",
    description: "Vocabulário sobre passagens, aeroportos e hotéis.",
    items: const [
      LessonItem(questionEn: "Ticket", answerPt: "Passagem/Bilhete", optionsPt: ["Mala", "Passagem/Bilhete", "Passaporte", "Hotel"]),
      LessonItem(questionEn: "Airport", answerPt: "Aeroporto", optionsPt: ["Aeroporto", "Estação", "Porto", "Ponto de ônibus"]),
      LessonItem(questionEn: "Luggage", answerPt: "Bagagem", optionsPt: ["Bolsa", "Mochila", "Bagagem", "Carteira"]),
      LessonItem(questionEn: "Flight", answerPt: "Voo", optionsPt: ["Carro", "Navio", "Voo", "Avião"]),
      LessonItem(questionEn: "Hotel", answerPt: "Hotel", optionsPt: ["Casa", "Quarto", "Hotel", "Fazenda"]),
      LessonItem(questionEn: "Passport", answerPt: "Passaporte", optionsPt: ["Passaporte", "Identidade", "Visto", "Assinatura"]),
      LessonItem(questionEn: "Trip", answerPt: "Viagem", optionsPt: ["Chegada", "Viagem", "Partida", "Encontro"]),
      LessonItem(questionEn: "Tourist", answerPt: "Turista", optionsPt: ["Guia", "Morador", "Estrangeiro", "Turista"]),
      LessonItem(questionEn: "Map", answerPt: "Mapa", optionsPt: ["Revista", "Direção", "Mapa", "Jornal"]),
      LessonItem(questionEn: "Train", answerPt: "Trem", optionsPt: ["Ônibus", "Trem", "Metrô", "Moto"]),
    ],
  ),
  Lesson(
    id: "l8",
    title: "Lição 8: Na Cidade",
    level: "Intermediário",
    description: "Lugares e direções vitais.",
    items: const [
      LessonItem(questionEn: "Hospital", answerPt: "Hospital", optionsPt: ["Escola", "Clínica", "Hospital", "Farmácia"]),
      LessonItem(questionEn: "School", answerPt: "Escola", optionsPt: ["Escola", "Faculdade", "Igreja", "Loja"]),
      LessonItem(questionEn: "Street", answerPt: "Rua", optionsPt: ["Rua", "Avenida", "Praça", "Ponte"]),
      LessonItem(questionEn: "Park", answerPt: "Parque", optionsPt: ["Jardim", "Parque", "Rua", "Shopping"]),
      LessonItem(questionEn: "Bank", answerPt: "Banco", optionsPt: ["Supermercado", "Cofre", "Dinheiro", "Banco"]),
      LessonItem(questionEn: "Supermarket", answerPt: "Supermercado", optionsPt: ["Loja", "Mercado", "Supermercado", "Shopping"]),
      LessonItem(questionEn: "Restaurant", answerPt: "Restaurante", optionsPt: ["Café", "Restaurante", "Lanchonete", "Bar"]),
      LessonItem(questionEn: "Pharmacy", answerPt: "Farmácia", optionsPt: ["Clínica", "Loja", "Farmácia", "Hospital"]),
      LessonItem(questionEn: "Left", answerPt: "Esquerda", optionsPt: ["Esquerda", "Direita", "Frente", "Reto"]),
      LessonItem(questionEn: "Right", answerPt: "Direita", optionsPt: ["Cima", "Trás", "Direita", "Baixo"]),
    ],
  ),
  Lesson(
    id: "l9",
    title: "Lição 9: Rotina e Ações",
    level: "Intermediário",
    description: "Verbos e ações comuns do cotidiano.",
    items: const [
      LessonItem(questionEn: "To walk", answerPt: "Andar", optionsPt: ["Correr", "Andar", "Pular", "Sentar"]),
      LessonItem(questionEn: "To eat", answerPt: "Comer", optionsPt: ["Beber", "Estudar", "Falar", "Comer"]),
      LessonItem(questionEn: "To sleep", answerPt: "Dormir", optionsPt: ["Acordar", "Sonhar", "Dormir", "Deitar"]),
      LessonItem(questionEn: "To study", answerPt: "Estudar", optionsPt: ["Ler", "Estudar", "Escrever", "Pensar"]),
      LessonItem(questionEn: "To work", answerPt: "Trabalhar", optionsPt: ["Divertir", "Trabalhar", "Descansar", "Focar"]),
      LessonItem(questionEn: "To speak", answerPt: "Falar", optionsPt: ["Falar", "Gritar", "Ouvir", "Cantar"]),
      LessonItem(questionEn: "To buy", answerPt: "Comprar", optionsPt: ["Vender", "Levar", "Dar", "Comprar"]),
      LessonItem(questionEn: "To run", answerPt: "Correr", optionsPt: ["Brincar", "Rastejar", "Correr", "Pular"]),
      LessonItem(questionEn: "To go", answerPt: "Ir", optionsPt: ["Ficar", "Ir", "Chegar", "Voltar"]),
      LessonItem(questionEn: "To make", answerPt: "Fazer", optionsPt: ["Fazer", "Construir", "Quebrar", "Lavar"]),
    ],
  ),
  Lesson(
    id: "l10",
    title: "Lição 10: Adjetivos Intermediários",
    level: "Intermediário",
    description: "Qualidades e sentimentos básicos.",
    items: const [
      LessonItem(questionEn: "Happy", answerPt: "Feliz", optionsPt: ["Triste", "Feliz", "Bravo", "Cansado"]),
      LessonItem(questionEn: "Sad", answerPt: "Triste", optionsPt: ["Zangado", "Solitário", "Triste", "Feliz"]),
      LessonItem(questionEn: "Angry", answerPt: "Bravo/Zangado", optionsPt: ["Nervoso", "Chateado", "Bravo/Zangado", "Calmo"]),
      LessonItem(questionEn: "Tired", answerPt: "Cansado", optionsPt: ["Com fome", "Cansado", "Dormindo", "Doente"]),
      LessonItem(questionEn: "Beautiful", answerPt: "Bonito(a)", optionsPt: ["Feio", "Rápido", "Bonito(a)", "Novo"]),
      LessonItem(questionEn: "Ugly", answerPt: "Feio(a)", optionsPt: ["Chato", "Feio(a)", "Bonito", "Velho"]),
      LessonItem(questionEn: "Fast", answerPt: "Rápido", optionsPt: ["Devagar", "Rápido", "Lento", "Cedo"]),
      LessonItem(questionEn: "Slow", answerPt: "Lento/Devagar", optionsPt: ["Tranquilo", "Rápido", "Lento/Devagar", "Tarde"]),
      LessonItem(questionEn: "New", answerPt: "Novo", optionsPt: ["Velho", "Atual", "Jovem", "Novo"]),
      LessonItem(questionEn: "Old", answerPt: "Velho/Antigo", optionsPt: ["Senhor", "Limpo", "Velho/Antigo", "Usado"]),
    ],
  ),
];
