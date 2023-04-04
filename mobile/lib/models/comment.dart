/// Classe modélisant un commentaire sur un événement
class Comment {
  Comment({
    required this.id,
    required this.idEvent,
    required this.idUser,
    required this.name,
    required this.comment,
    required this.createdAt,
  });

  /// id du commentaire
  String id;

  /// id de l'événement auquel le commentaire est associé
  String idEvent;

  /// id de l'utilisateur qui a posté le commentaire
  String idUser;

  /// nom de l'utilisateur qui a posté le commentaire
  String name;

  /// message du commentaire
  String comment = "";

  /// date de création du commentaire
  DateTime createdAt;

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
