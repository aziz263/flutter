class DetailPickListadd {
  final String emplacement;
  final int quantite;
  const DetailPickListadd({
    required this.emplacement,
    required this.quantite,
  });
  factory DetailPickListadd.fromJson(Map<String, dynamic> json) =>
      DetailPickListadd(
        emplacement: json['emplacement'],
        quantite: json['quantité'],
      );
  Map<String, dynamic> toJson() => {
        "emplacement": emplacement,
        'quantité': quantite,
      };
}
