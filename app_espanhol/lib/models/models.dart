class LearnWord {
  final int id;
  final int categoryId;
  final String english;
  final String portuguese;
  final String french;
  final String german;
  final String spanish;

  LearnWord({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.portuguese,
    required this.french,
    required this.german,
    required this.spanish,
  });

  factory LearnWord.fromMap(Map<String, dynamic> json) => LearnWord(
        id: json["Id"],
        categoryId: json["CategoryId"] ?? 0,
        english: json["English"] ?? "",
        portuguese: json["Portuguese"] ?? "",
        french: json["French"] ?? "",
        german: json["German"] ?? "",
        spanish: json["Spanish"] ?? "",
      );

  String getByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
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

  LearnPhrase({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.french,
    required this.german,
    required this.portuguese,
    required this.spanish,
  });

  factory LearnPhrase.fromMap(Map<String, dynamic> json) => LearnPhrase(
        id: json["Id"],
        categoryId: json["CategoryId"] ?? 0,
        english: json["English"] ?? "",
        french: json["French"] ?? "",
        german: json["German"] ?? "",
        portuguese: json["Portuguese"] ?? "",
        spanish: json["Spanish"] ?? "",
      );

  String getByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
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
  final String eWord;
  final String pWord;
  final String sWord;
  final String gWord;
  final String fWord;

  LearnSentence({
    required this.id,
    required this.english,
    required this.portuguese,
    required this.spanish,
    required this.german,
    required this.french,
    required this.eWord,
    required this.pWord,
    required this.sWord,
    required this.gWord,
    required this.fWord,
  });

  factory LearnSentence.fromMap(Map<String, dynamic> json) => LearnSentence(
        id: json["Id"],
        english: json["English"] ?? "",
        portuguese: json["Portuguese"] ?? "",
        spanish: json["Spanish"] ?? "",
        german: json["German"] ?? "",
        french: json["French"] ?? "",
        eWord: json["EWord"] ?? "",
        pWord: json["PWord"] ?? "",
        sWord: json["SWord"] ?? "",
        gWord: json["GWord"] ?? "",
        fWord: json["FWord"] ?? "",
      );

  String getSentenceByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
      default: return english;
    }
  }

  String getWordByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return fWord;
      case 'german': return gWord;
      case 'portuguese': return pWord;
      case 'spanish': return sWord;
      default: return eWord;
    }
  }
}
