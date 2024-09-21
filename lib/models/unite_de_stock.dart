class UniteDeStock {
  final int idUs;
  final String us;
  final int quantite;
  final String article;

  UniteDeStock({
    required this.idUs,
    required this.us,
    required this.quantite,
    required this.article,
  });

  factory UniteDeStock.fromJson(Map<String, dynamic> json) {
    return UniteDeStock(
      idUs: json['id'],
      us: json['us'],
      article: json['article'],
      quantite: json['quantite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idUs,
      'us': us,
      'article': article,
      'quantite': quantite,
    };
  }
}
