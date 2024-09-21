class Article {
  final int? idArticle;
  final String articleData;

  const Article({
    this.idArticle,
    required this.articleData,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      idArticle: json['idArticle'],
      articleData: json['articleData'],
    );
  }

  Map<String, dynamic> toJson() => {
        "articleData": articleData,
      };
}
