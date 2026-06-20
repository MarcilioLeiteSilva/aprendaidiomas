class LearnWord {
  final int id;
  final int categoryId;
  final String english;
  final String portuguese;
  final String french;
  final String german;
  final String spanish;
  final String italian;

  LearnWord({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.portuguese,
    required this.french,
    required this.german,
    required this.spanish,
    required this.italian,
  });

  factory LearnWord.fromMap(Map<String, dynamic> json) => LearnWord(
        id: json["Id"],
        categoryId: json["CategoryId"] ?? 0,
        english: json["English"] ?? "",
        portuguese: json["Portuguese"] ?? "",
        french: json["French"] ?? "",
        german: json["German"] ?? "",
        spanish: json["Spanish"] ?? "",
        italian: json["Italian"] ?? "",
      );

  String getByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
      case 'italian': return italian;
      default: return english;
    }
  }
}

class LearnPhrase {
  final int id;
  final int categoryId;
  final String english;
  final String french;
  final String german;
  final String portuguese;
  final String spanish;
  final String italian;

  LearnPhrase({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.french,
    required this.german,
    required this.portuguese,
    required this.spanish,
    required this.italian,
  });

  factory LearnPhrase.fromMap(Map<String, dynamic> json) => LearnPhrase(
        id: json["Id"],
        categoryId: json["CategoryId"] ?? 0,
        english: json["English"] ?? "",
        french: json["French"] ?? "",
        german: json["German"] ?? "",
        portuguese: json["Portuguese"] ?? "",
        spanish: json["Spanish"] ?? "",
        italian: json["Italian"] ?? "",
      );

  String getByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
      case 'italian': return italian;
      default: return english;
    }
  }
}

class LearnSentence {
  final int id;
  final String english;
  final String portuguese;
  final String spanish;
  final String german;
  final String french;
  final String italian;
  final String eWord;
  final String pWord;
  final String sWord;
  final String gWord;
  final String fWord;
  final String iWord;

  LearnSentence({
    required this.id,
    required this.english,
    required this.portuguese,
    required this.spanish,
    required this.german,
    required this.french,
    required this.italian,
    required this.eWord,
    required this.pWord,
    required this.sWord,
    required this.gWord,
    required this.fWord,
    required this.iWord,
  });

  factory LearnSentence.fromMap(Map<String, dynamic> json) => LearnSentence(
        id: json["Id"],
        english: json["English"] ?? "",
        portuguese: json["Portuguese"] ?? "",
        spanish: json["Spanish"] ?? "",
        german: json["German"] ?? "",
        french: json["French"] ?? "",
        italian: json["Italian"] ?? "",
        eWord: json["EWord"] ?? "",
        pWord: json["PWord"] ?? "",
        sWord: json["SWord"] ?? "",
        gWord: json["GWord"] ?? "",
        fWord: json["FWord"] ?? "",
        iWord: json["IWord"] ?? "",
      );

  String getSentenceByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
      case 'italian': return italian;
      default: return english;
    }
  }

  String getWordByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return fWord;
      case 'german': return gWord;
      case 'portuguese': return pWord;
      case 'spanish': return sWord;
      case 'italian': return iWord;
      default: return eWord;
    }
  }
}
