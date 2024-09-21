class Magasinier {
  final int idmagasinier;
  final String nom;
  final String prenom;
  final String mail;
  final String password;
  final int age;
  final int adminRole;
  final int? qrCode;
  const Magasinier({
    required this.idmagasinier,
    required this.nom,
    required this.prenom,
    required this.mail,
    required this.password,
    required this.age,
    required this.adminRole,
    this.qrCode,
  });
  factory Magasinier.fromJson(Map<String, dynamic> json) => Magasinier(
        idmagasinier: json['idMagasinier'] ?? "",
        nom: json['nom'] ?? "",
        prenom: json['prenom'] ?? "",
        mail: json['mail'] ?? "",
        password: json['password'] ?? "",
        age: json['age'] ?? "",
        adminRole: json['adminRole'] ?? "",
        qrCode: json['qrCode'] ?? 0,
      );
  Map<String, dynamic> toJson() => {
        "idMagasinier": idmagasinier,
        "nom": nom,
        "prenom": prenom,
        "mail": mail,
        "password": password,
        "age": age,
        "adminRole": adminRole,
        "qrCode": qrCode ?? 0,
      };
}
