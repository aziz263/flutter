class Magasin {
  final int idMg;
  final String nomMg;

  Magasin({
    required this.idMg,
    required this.nomMg,
  });

  factory Magasin.fromJson(Map<String, dynamic> json) {
    return Magasin(
      idMg: json['idMg'],
      nomMg: json['nomMg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMg': idMg,
      'nomMg': nomMg,
    };
  }
}
