class MagasinierUpdate {
  // final int idmagasinier;
  final String nom;
  final String prenom;
  final String mail;
 
  final int age;
  final int adminRole;
  final String? password;
  const MagasinierUpdate({
   
    required this.nom,
    required this.prenom,
    required this.mail,
    this.password,

    required this.age,
    required this.adminRole,
  });
  factory MagasinierUpdate.fromJson(Map<String, dynamic> json) => MagasinierUpdate(
        // idmagasinier: json['idMagasinier']??"",
        nom: json['nom']??"",
        prenom: json['prenom']??"",
        mail: json['mail']??"",
      
        age: json['age']??"",
        adminRole: json['adminRole']??"",
        password: json['password']??"",
      );
  Map<String, dynamic> toJson() => {
        // "idMagasinier": idmagasinier,
        "nom": nom,
        "prenom": prenom,
        "mail": mail,
     
        "age": age,
        "adminRole": adminRole,
        "password": password ?? "",
      };
}
