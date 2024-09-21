class Statue {
  final int idSt;
  final String codeSt;

  Statue({
    required this.idSt,
    required this.codeSt,
  });

  factory Statue.fromJson(Map<String, dynamic> json) {
    return Statue(
      idSt: json['idSt'],
      codeSt: json['codeSt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSt': idSt,
      'codeSt': codeSt,
    };
  }
}
