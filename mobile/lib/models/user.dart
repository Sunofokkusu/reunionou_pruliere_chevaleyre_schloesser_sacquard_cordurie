/// Classe modélisant un utilisateur

class User {// Constructeur
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  String id; // id de l'utilisateur
  String name; // nom de l'utilisateur
  String email; // email de l'utilisateur

  /// Méthode de création d'un utilisateur à partir d'un json
  static User fromJson(data) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['mail'],
    );
  }
}
