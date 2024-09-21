class LigneAdd {
  final String numLigne;

  LigneAdd({
    required this.numLigne,
  });

  factory LigneAdd.fromJson(Map<String, dynamic> json) {
    return LigneAdd(
      numLigne: json['numLigne'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numLigne': numLigne,
    };
  }
}
