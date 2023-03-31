class Message {
  Message({
    required this.name,
    this.message,
    required this.status,
  });

  String name;

  String? message;
  int status;
  DateTime createdAt = DateTime.now();

  static Message fromJson(data) {
    return Message(
      name: data['name'],
      message: data['message'],
      status: data['status'],
    );
  }
}