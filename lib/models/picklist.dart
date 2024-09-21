class PickList {
  final int idPickList;
  final DateTime date;
  final String nomMagasin;
  final int numLigne;
  final String codeSt;

  PickList({
    required this.idPickList,
    required this.date,
    required this.nomMagasin,
    required this.numLigne,
    required this.codeSt,
  });

  factory PickList.fromJson(Map<String, dynamic> json) {
    return PickList(
      idPickList: json['idPickList']??'',
      date: DateTime.parse(json['date']??''),
      nomMagasin: json['nomMagasin']??'',
      numLigne: json['numLigne']??'',
      codeSt: json['codeSt']??'',
    );
  }
  Map<String, dynamic> toJson() => {
        // "idMg": idMg,
        // "idLigne":idLigne,
        // "idSt":idSt,
        "date": date,
      };
}
