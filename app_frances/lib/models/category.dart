class LearnCategory {
  final int id;
  final String english;
  final String french;
  final String german;
  final String portuguese;
  final String spanish;

  LearnCategory({
    required this.id,
    required this.english,
    required this.french,
    required this.german,
    required this.portuguese,
    required this.spanish,
  });

  factory LearnCategory.fromMap(Map<String, dynamic> json) => LearnCategory(
        id: json["Id"],
        english: json["CEnglish"] ?? "",
        french: json["CFrench"]?.toString() ?? "",
        german: json["CGerman"]?.toString() ?? "",
        portuguese: json["CPortuguese"]?.toString() ?? "",
        spanish: json["CSpanish"]?.toString() ?? "",
      );

  String getNameByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
      default: return english;
    }
  }
}

class LearnPhraseCategory {
  final int id;
  final String english;
  final String french;
  final String german;
  final String portuguese;
  final String spanish;

  LearnPhraseCategory({
    required this.id,
    required this.english,
    required this.french,
    required this.german,
    required this.portuguese,
    required this.spanish,
  });

  factory LearnPhraseCategory.fromMap(Map<String, dynamic> json) => LearnPhraseCategory(
        id: json["Id"],
        english: json["EnglishCategory"] ?? "",
        french: json["FrenchCategory"]?.toString() ?? "",
        german: json["GermanCategory"]?.toString() ?? "",
        portuguese: json["PortugueseCategory"]?.toString() ?? "",
        spanish: json["SpanishCategory"]?.toString() ?? "",
      );

  String getNameByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'french': return french;
      case 'german': return german;
      case 'portuguese': return portuguese;
      case 'spanish': return spanish;
      default: return english;
    }
  }
}

