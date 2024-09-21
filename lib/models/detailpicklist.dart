class DetailPicklist {
  final int idDetailPickList;
  final String article;
  final String emplacement;
  final int quantite;
  final String codeSt;
  final int? idPicklist;

  DetailPicklist({
    required this.idDetailPickList,
    required this.article,
    required this.emplacement,
    required this.quantite,
    required this.codeSt,
    this.idPicklist,
  });

  factory DetailPicklist.fromJson(Map<String, dynamic> json) {
    return DetailPicklist(
      idDetailPickList: json['id'],
      article: json['article'],
      emplacement: json['emplacement'],
      codeSt: json['codeSt'],
      quantite: json['quantité'],
      idPicklist: json['idPicklist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idDetailPickList,
      'article': article,
      'emplacement': emplacement,
      'codeSt': codeSt,
      'quantité': quantite,
      'idPicklist': idPicklist,
    };
  }
}
