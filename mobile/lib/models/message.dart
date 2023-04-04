/// Classe modélisant un message de participation à un événement
class Message {
  /// Constructeur
  Message({
    this.idAuthor,
    required this.name,
    this.message,
    required this.status,
  });

  /// nom de l'utilisateur
  String? idAuthor;

  /// nom de l'utilisateur
  String name;

  /// message de l'utilisateur
  String? message;

  /// statut de l'utilisateur
  int status;

  /// date de création du message
  DateTime createdAt = DateTime.now();

  /// Méthode de création d'un message à partir d'un json
  static Message fromJson(data) {
    return Message(
      idAuthor: data['id_user'],
      name: data['name'],
      message: data['message'],
      status: data['status'],
    );
  }
}
