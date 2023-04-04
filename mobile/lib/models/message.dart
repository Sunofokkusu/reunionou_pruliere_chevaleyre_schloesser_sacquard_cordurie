class Message {
  Message({
    this.idAuthor,
    required this.name,
    this.message,
    required this.status,
  });

  String name;
  String? idAuthor;
  String? message;
  int status;
  DateTime createdAt = DateTime.now();

  static Message fromJson(data) {
    return Message(
      idAuthor: data['id_user'],
      name: data['name'],
      message: data['message'],
      status: data['status'],
    );
  }
}
