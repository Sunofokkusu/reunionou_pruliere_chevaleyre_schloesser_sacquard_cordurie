/// Classe modélisant un commentaire sur un événement
class Comment {
  Comment({ // Constructeur de la classe
    required this.id,
    required this.idEvent,
    required this.idUser,
    required this.name,
    required this.comment,
    required this.createdAt,
  });

  String id; // id du commentaire
  String idEvent; // id de l'événement auquel le commentaire est associé
  String idUser; // id de l'utilisateur qui a posté le commentaire
  String name; // nom de l'utilisateur qui a posté le commentaire
  String comment = ""; // commentaire
  DateTime createdAt; // date de création

  /// Méthode de création d'un commentaire à partir d'un json
  static Comment fromJson(data) {
    return Comment(
      id: data['id'],
      idEvent: data['id_event'],
      idUser: data['id_user'],
      name: data['name'],
      comment: data['comment'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
