import 'magasin.dart'; 

class DetailPickliste {
  final int idDetailPickList;
  final String article;
  final String emplacement;
  final int quantite;
  final String codeSt;
  final Magasin magasin; 


  DetailPickliste({
    required this.idDetailPickList,
    required this.article,
    required this.emplacement,
    required this.codeSt,
    required this.magasin, 
    required this.quantite,
  });

  factory DetailPickliste.fromJson(Map<String, dynamic> json) {
    return DetailPickliste(
      idDetailPickList: json['idDetailPickList'],
      article: json['article'],
      emplacement: json['emplacement'],
      quantite: json['quantité'],
      codeSt: json['codeSt'],
      magasin: Magasin.fromJson(json['magasin']), 

    );
  }
}
