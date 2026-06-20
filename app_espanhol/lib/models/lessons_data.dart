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

// Global mock state for lessons in Spanish.
final List<Lesson> appLessons = [
  Lesson(
    id: "l1",
    title: "Lição 1: O Básico",
    level: "Fácil",
    description: "Cumprimentos e palavras essenciais do dia a dia em espanhol.",
    items: const [
      LessonItem(questionEn: "Hola", answerPt: "Olá", optionsPt: ["Obrigado", "Olá", "Adeus", "Sim"]),
      LessonItem(questionEn: "Buenos días", answerPt: "Bom dia", optionsPt: ["Boa noite", "Bom dia", "Com licença", "Não"]),
      LessonItem(questionEn: "Gracias", answerPt: "Obrigado", optionsPt: ["Obrigado", "Desculpe", "Por favor", "De nada"]),
      LessonItem(questionEn: "Sí", answerPt: "Sim", optionsPt: ["Não", "Sim", "Talvez", "Sempre"]),
      LessonItem(questionEn: "Adiós", answerPt: "Adeus", optionsPt: ["Bem vindo", "Bom dia", "Adeus", "Oi"]),
      LessonItem(questionEn: "Por favor", answerPt: "Por favor", optionsPt: ["Por favor", "De nada", "Oi", "Desculpe"]),
      LessonItem(questionEn: "Lo siento", answerPt: "Desculpe", optionsPt: ["Perdão", "Bom dia", "Desculpe", "Nada"]),
      LessonItem(questionEn: "Buenas noches", answerPt: "Boa noite", optionsPt: ["Bom dia", "Boa tarde", "Boa noite", "Até logo"]),
      LessonItem(questionEn: "De nada", answerPt: "De nada", optionsPt: ["Por favor", "De nada", "Sim", "Até amanhã"]),
      LessonItem(questionEn: "Hola", answerPt: "Oi", optionsPt: ["Olá", "Oi", "Tchau", "Certo"]),
    ],
  ),
  Lesson(
    id: "l2",
    title: "Lição 2: Números",
    level: "Fácil",
    description: "Aprenda a contar de 1 a 10 em espanhol.",
    items: const [
      LessonItem(questionEn: "Uno", answerPt: "Um", optionsPt: ["Dois", "Três", "Um", "Dez"]),
      LessonItem(questionEn: "Dos", answerPt: "Dois", optionsPt: ["Quatro", "Dez", "Dois", "Um"]),
      LessonItem(questionEn: "Tres", answerPt: "Três", optionsPt: ["Três", "Oito", "Seis", "Nove"]),
      LessonItem(questionEn: "Cuatro", answerPt: "Quatro", optionsPt: ["Cinco", "Quatro", "Onze", "Três"]),
      LessonItem(questionEn: "Cinco", answerPt: "Cinco", optionsPt: ["Dez", "Oito", "Dois", "Cinco"]),
      LessonItem(questionEn: "Seis", answerPt: "Seis", optionsPt: ["Sete", "Seis", "Quatro", "Três"]),
      LessonItem(questionEn: "Siete", answerPt: "Sete", optionsPt: ["Nove", "Sete", "Oito", "Dois"]),
      LessonItem(questionEn: "Ocho", answerPt: "Oito", optionsPt: ["Oito", "Um", "Dez", "Sete"]),
      LessonItem(questionEn: "Nueve", answerPt: "Nove", optionsPt: ["Dez", "Cinco", "Dois", "Nove"]),
      LessonItem(questionEn: "Diez", answerPt: "Dez", optionsPt: ["Um", "Três", "Dez", "Sete"]),
    ],
  ),
  Lesson(
    id: "l3",
    title: "Lição 3: Cores",
    level: "Fácil",
    description: "Cores fundamentais em espanhol.",
    items: const [
      LessonItem(questionEn: "Rojo", answerPt: "Vermelho", optionsPt: ["Azul", "Vermelho", "Verde", "Amarelo"]),
      LessonItem(questionEn: "Azul", answerPt: "Azul", optionsPt: ["Amarelo", "Violeta", "Azul", "Preto"]),
      LessonItem(questionEn: "Verde", answerPt: "Verde", optionsPt: ["Verde", "Rosa", "Cinza", "Branco"]),
      LessonItem(questionEn: "Amarillo", answerPt: "Amarelo", optionsPt: ["Preto", "Rosa", "Laranja", "Amarelo"]),
      LessonItem(questionEn: "Negro", answerPt: "Preto", optionsPt: ["Preto", "Turquesa", "Marrom", "Azul"]),
      LessonItem(questionEn: "Blanco", answerPt: "Branco", optionsPt: ["Lilás", "Cinza", "Verde", "Branco"]),
      LessonItem(questionEn: "Naranja", answerPt: "Laranja", optionsPt: ["Vermelho", "Laranja", "Preto", "Bordô"]),
      LessonItem(questionEn: "Rosa", answerPt: "Rosa", optionsPt: ["Rosa", "Azul", "Lilás", "Amarelo"]),
      LessonItem(questionEn: "Marrón", answerPt: "Marrom", optionsPt: ["Verde", "Marrom", "Cinza", "Preto"]),
      LessonItem(questionEn: "Gris", answerPt: "Cinza", optionsPt: ["Amarelo", "Cinza", "Branco", "Rosa"]),
    ],
  ),
  Lesson(
    id: "l4",
    title: "Lição 4: Família",
    level: "Fácil",
    description: "Membros da família e relacionamentos em espanhol.",
    items: const [
      LessonItem(questionEn: "Madre", answerPt: "Mãe", optionsPt: ["Tia", "Mãe", "Prima", "Avó"]),
      LessonItem(questionEn: "Padre", answerPt: "Pai", optionsPt: ["Pai", "Tio", "Avô", "Irmão"]),
      LessonItem(questionEn: "Hermano", answerPt: "Irmão", optionsPt: ["Primo", "Tio", "Irmão", "Avô"]),
      LessonItem(questionEn: "Hermana", answerPt: "Irmã", optionsPt: ["Irmã", "Mãe", "Amiga", "Tia"]),
      LessonItem(questionEn: "Abuela", answerPt: "Avó", optionsPt: ["Avó", "Mãe", "Sobrinha", "Tia"]),
      LessonItem(questionEn: "Abuelo", answerPt: "Avô", optionsPt: ["Pai", "Tio", "Neto", "Avô"]),
      LessonItem(questionEn: "Tío", answerPt: "Tio", optionsPt: ["Primo", "Tio", "Avô", "Amigo"]),
      LessonItem(questionEn: "Tía", answerPt: "Tia", optionsPt: ["Tia", "Avó", "Cunhada", "Irmã"]),
      LessonItem(questionEn: "Primo / Prima", answerPt: "Primo/Prima", optionsPt: ["Amigo", "Filho", "Primo/Prima", "Neto"]),
      LessonItem(questionEn: "Hijo", answerPt: "Filho", optionsPt: ["Irmão", "Filho", "Sobrinho", "Neto"]),
    ],
  ),
  Lesson(
    id: "l5",
    title: "Lição 5: Animais",
    level: "Fácil",
    description: "Animais domésticos e selvagens em espanhol.",
    items: const [
      LessonItem(questionEn: "Perro", answerPt: "Cachorro", optionsPt: ["Gato", "Pássaro", "Cachorro", "Peixe"]),
      LessonItem(questionEn: "Gato", answerPt: "Gato", optionsPt: ["Gato", "Sapo", "Coelho", "Cachorro"]),
      LessonItem(questionEn: "Pájaro", answerPt: "Pássaro", optionsPt: ["Galinha", "Pássaro", "Vaca", "Pato"]),
      LessonItem(questionEn: "Pez", answerPt: "Peixe", optionsPt: ["Peixe", "Sapo", "Cobra", "Baleia"]),
      LessonItem(questionEn: "Caballo", answerPt: "Cavalo", optionsPt: ["Ovelha", "Cavalo", "Boi", "Porco"]),
      LessonItem(questionEn: "Vaca", answerPt: "Vaca", optionsPt: ["Vaca", "Tartaruga", "Cavalo", "Ovelha"]),
      LessonItem(questionEn: "Mono", answerPt: "Macaco", optionsPt: ["Leão", "Macaco", "Urso", "Zebra"]),
      LessonItem(questionEn: "León", answerPt: "Leão", optionsPt: ["Tigre", "Elefante", "Leão", "Jacaré"]),
      LessonItem(questionEn: "Elefante", answerPt: "Elefante", optionsPt: ["Girafa", "Zebra", "Elefante", "Panda"]),
      LessonItem(questionEn: "Oso", answerPt: "Urso", optionsPt: ["Lobo", "Raposa", "Leão", "Urso"]),
    ],
  ),
  Lesson(
    id: "l6",
    title: "Lição 6: Alimentos",
    level: "Pré-Intermediário",
    description: "Comidas e bebidas em espanhol.",
    items: const [
      LessonItem(questionEn: "Agua", answerPt: "Água", optionsPt: ["Suco", "Água", "Leite", "Café"]),
      LessonItem(questionEn: "Pan", answerPt: "Pão", optionsPt: ["Pão", "Bolo", "Queijo", "Manteiga"]),
      LessonItem(questionEn: "Queso", answerPt: "Queijo", optionsPt: ["Ovo", "Presunto", "Queijo", "Carne"]),
      LessonItem(questionEn: "Carne", answerPt: "Carne", optionsPt: ["Frango", "Peixe", "Fruta", "Carne"]),
      LessonItem(questionEn: "Pollo", answerPt: "Frango", optionsPt: ["Boi", "Porco", "Frango", "Ovelha"]),
      LessonItem(questionEn: "Manzana", answerPt: "Maçã", optionsPt: ["Banana", "Maçã", "Uva", "Pera"]),
      LessonItem(questionEn: "Café", answerPt: "Café", optionsPt: ["Café", "Chá", "Água", "Refrigerante"]),
      LessonItem(questionEn: "Té", answerPt: "Chá", optionsPt: ["Cerveja", "Café", "Chá", "Suco"]),
      LessonItem(questionEn: "Leche", answerPt: "Leite", optionsPt: ["Água", "Iogurte", "Leite", "Queijo"]),
      LessonItem(questionEn: "Arroz", answerPt: "Arroz", optionsPt: ["Feijão", "Arroz", "Trigo", "Pão"]),
    ],
  ),
  Lesson(
    id: "l7",
    title: "Lição 7: Viagem",
    level: "Pré-Intermediário",
    description: "Vocabulário sobre passagens, aeroportos e hotéis em espanhol.",
    items: const [
      LessonItem(questionEn: "Billete", answerPt: "Passagem/Bilhete", optionsPt: ["Mala", "Passagem/Bilhete", "Passaporte", "Hotel"]),
      LessonItem(questionEn: "Aeropuerto", answerPt: "Aeroporto", optionsPt: ["Aeroporto", "Estação", "Porto", "Ponto de ônibus"]),
      LessonItem(questionEn: "Equipaje", answerPt: "Bagagem", optionsPt: ["Bolsa", "Mochila", "Bagagem", "Carteira"]),
      LessonItem(questionEn: "Vuelo", answerPt: "Voo", optionsPt: ["Carro", "Navio", "Voo", "Avião"]),
      LessonItem(questionEn: "Hotel", answerPt: "Hotel", optionsPt: ["Casa", "Quarto", "Hotel", "Fazenda"]),
      LessonItem(questionEn: "Pasaporte", answerPt: "Passaporte", optionsPt: ["Passaporte", "Identidade", "Visto", "Assinatura"]),
      LessonItem(questionEn: "Viaje", answerPt: "Viagem", optionsPt: ["Chegada", "Viagem", "Partida", "Encontro"]),
      LessonItem(questionEn: "Turista", answerPt: "Turista", optionsPt: ["Guia", "Morador", "Estrangeiro", "Turista"]),
      LessonItem(questionEn: "Mapa", answerPt: "Mapa", optionsPt: ["Revista", "Direção", "Mapa", "Jornal"]),
      LessonItem(questionEn: "Tren", answerPt: "Trem", optionsPt: ["Ônibus", "Trem", "Metrô", "Moto"]),
    ],
  ),
  Lesson(
    id: "l8",
    title: "Lição 8: Na Cidade",
    level: "Intermediário",
    description: "Lugares e direções vitais em espanhol.",
    items: const [
      LessonItem(questionEn: "Hospital", answerPt: "Hospital", optionsPt: ["Escola", "Clínica", "Hospital", "Farmácia"]),
      LessonItem(questionEn: "Escuela", answerPt: "Escola", optionsPt: ["Escola", "Faculdade", "Igreja", "Loja"]),
      LessonItem(questionEn: "Calle", answerPt: "Rua", optionsPt: ["Rua", "Avenida", "Praça", "Ponte"]),
      LessonItem(questionEn: "Parque", answerPt: "Parque", optionsPt: ["Jardim", "Parque", "Rua", "Shopping"]),
      LessonItem(questionEn: "Banco", answerPt: "Banco", optionsPt: ["Supermercado", "Cofre", "Dinheiro", "Banco"]),
      LessonItem(questionEn: "Supermercado", answerPt: "Supermercado", optionsPt: ["Loja", "Mercado", "Supermercado", "Shopping"]),
      LessonItem(questionEn: "Restaurante", answerPt: "Restaurante", optionsPt: ["Café", "Restaurante", "Lanchonete", "Bar"]),
      LessonItem(questionEn: "Farmacia", answerPt: "Farmácia", optionsPt: ["Clínica", "Loja", "Farmácia", "Hospital"]),
      LessonItem(questionEn: "Izquierda", answerPt: "Esquerda", optionsPt: ["Esquerda", "Direita", "Frente", "Reto"]),
      LessonItem(questionEn: "Derecha", answerPt: "Direita", optionsPt: ["Cima", "Trás", "Direita", "Baixo"]),
    ],
  ),
  Lesson(
    id: "l9",
    title: "Lição 9: Rotina e Ações",
    level: "Intermediário",
    description: "Verbos e ações comuns do cotidiano em espanhol.",
    items: const [
      LessonItem(questionEn: "Caminar", answerPt: "Andar", optionsPt: ["Correr", "Andar", "Pular", "Sentar"]),
      LessonItem(questionEn: "Comer", answerPt: "Comer", optionsPt: ["Beber", "Estudar", "Falar", "Comer"]),
      LessonItem(questionEn: "Dormir", answerPt: "Dormir", optionsPt: ["Acordar", "Sonhar", "Dormir", "Deitar"]),
      LessonItem(questionEn: "Estudiar", answerPt: "Estudar", optionsPt: ["Ler", "Estudar", "Escrever", "Pensar"]),
      LessonItem(questionEn: "Trabajar", answerPt: "Trabalhar", optionsPt: ["Divertir", "Trabalhar", "Descansar", "Focar"]),
      LessonItem(questionEn: "Hablar", answerPt: "Falar", optionsPt: ["Falar", "Gritar", "Ouvir", "Cantar"]),
      LessonItem(questionEn: "Comprar", answerPt: "Comprar", optionsPt: ["Vender", "Levar", "Dar", "Comprar"]),
      LessonItem(questionEn: "Correr", answerPt: "Correr", optionsPt: ["Brincar", "Rastejar", "Correr", "Pular"]),
      LessonItem(questionEn: "Ir", answerPt: "Ir", optionsPt: ["Ficar", "Ir", "Chegar", "Voltar"]),
      LessonItem(questionEn: "Hacer", answerPt: "Fazer", optionsPt: ["Fazer", "Construir", "Quebrar", "Lavar"]),
    ],
  ),
  Lesson(
    id: "l10",
    title: "Lição 10: Adjetivos Intermediários",
    level: "Intermediário",
    description: "Qualidades e sentimentos básicos em espanhol.",
    items: const [
      LessonItem(questionEn: "Feliz", answerPt: "Feliz", optionsPt: ["Triste", "Feliz", "Bravo", "Cansado"]),
      LessonItem(questionEn: "Triste", answerPt: "Triste", optionsPt: ["Zangado", "Solitário", "Triste", "Feliz"]),
      LessonItem(questionEn: "Enojado / Enfadado", answerPt: "Bravo/Zangado", optionsPt: ["Nervoso", "Chateado", "Bravo/Zangado", "Calmo"]),
      LessonItem(questionEn: "Cansado", answerPt: "Cansado", optionsPt: ["Com fome", "Cansado", "Dormindo", "Doente"]),
      LessonItem(questionEn: "Bonito / Hermoso", answerPt: "Bonito(a)", optionsPt: ["Feio", "Rápido", "Bonito(a)", "Novo"]),
      LessonItem(questionEn: "Feo", answerPt: "Feio(a)", optionsPt: ["Chato", "Feio(a)", "Bonito", "Velho"]),
      LessonItem(questionEn: "Rápido", answerPt: "Rápido", optionsPt: ["Devagar", "Rápido", "Lento", "Cedo"]),
      LessonItem(questionEn: "Lento", answerPt: "Lento/Devagar", optionsPt: ["Tranquilo", "Rápido", "Lento/Devagar", "Tarde"]),
      LessonItem(questionEn: "Nuevo", answerPt: "Novo", optionsPt: ["Velho", "Atual", "Jovem", "Novo"]),
      LessonItem(questionEn: "Viejo", answerPt: "Velho/Antigo", optionsPt: ["Senhor", "Limpo", "Velho/Antigo", "Usado"]),
    ],
  ),
];
