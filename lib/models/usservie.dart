class UsServie {
  final int idUsServi;
  final String us;
  final int quantite;
  final String emplacement;
  final String mail;
  final String article;
  final int idPicklist;
  final int idDetailPicklist;

  UsServie({
    required this.idUsServi,
    required this.us,
    required this.quantite,
    required this.emplacement,
    required this.mail,
    required this.article,
    required this.idPicklist,
    required this.idDetailPicklist,
  });

  factory UsServie.fromJson(Map<String, dynamic> json) {
    return UsServie(
      idUsServi: json['idUsServi'],
      us: json['us'],
      quantite: json['quantité'],
      emplacement: json['emplacement'],
      article: json['article'],
      mail: json['mail'],
      idPicklist: json['idPicklist'],
      idDetailPicklist: json['idDetailPicklist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsServi': idUsServi,
      'us': us,
      'quantité': quantite,
      'emplacement': emplacement,
      'article': article,
      'mail': mail,
      'idPicklist': idPicklist,
      'idDetailPicklist': idDetailPicklist,
    };
  }
}
