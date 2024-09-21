class Ligne {
  // final int  idMg;
  // final int idLigne;
  final int idLigne;
  final int numLigne;
  const Ligne({
    // required this.idMg,
    // required this.idLigne,
    required this.idLigne,
    required this.numLigne,
  });
  factory Ligne.fromJson(Map<String, dynamic> json) => Ligne(
        // idMg: json['idMg'],
        // idLigne: json['idLigne'],
        idLigne: json['idLigne'],
        numLigne: json['numLigne'],
      );
  Map<String, dynamic> toJson() => {
        // "idMg": idMg,
        // "idLigne":idLigne,
        "idLigne": idLigne,
        "numLigne": numLigne,
      };
}
