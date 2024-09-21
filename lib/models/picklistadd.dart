class PickListadd {
  // final int  idMg;
  // final int idLigne;
  // final int idSt;
  final String date;
  const PickListadd({
    // required this.idMg,
    // required this.idLigne,
    // required this.idSt,
    required this.date,
  });
  factory PickListadd.fromJson(Map<String, dynamic> json) => PickListadd(
        // idMg: json['idMg'],
        // idLigne: json['idLigne'],
        // idSt: json['idSt'],
        date: json['date'],
      );
  Map<String, dynamic> toJson() => {
        // "idMg": idMg,
        // "idLigne":idLigne,
        // "idSt":idSt,
        "date": date,
      };
}
