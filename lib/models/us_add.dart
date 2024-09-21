class UsAdd {
  final String us;
  final String article;
  final String quantite;

  UsAdd({
    required this.us,
    required this.article,
    required this.quantite,
  });

  factory UsAdd.fromJson(Map<String, dynamic> json) {
    return UsAdd(
      us: json['us'],
      article: json['article'],
      quantite: json['quantite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'us': us,
      'article': article,
      'quantite': quantite,
    };
  }
}
