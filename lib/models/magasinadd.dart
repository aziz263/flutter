class MagasinAdd {
  final String nomMg;

  MagasinAdd({
    required this.nomMg,
  });

  factory MagasinAdd.fromJson(Map<String, dynamic> json) {
    return MagasinAdd(
      nomMg: json['nomMg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomMg': nomMg,
    };
  }
  


}
