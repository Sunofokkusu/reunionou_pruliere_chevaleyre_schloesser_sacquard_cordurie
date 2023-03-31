class Message {
  Message({
    required this.name,
    required this.email,
    required this.message,
    required this.status,
  });

  String name;
  String email;
  String message;
  int status;
  DateTime createdAt = DateTime.now();

  static Message fromJson(data) {
    return Message(
      name: data['name'],
      email: data['email'],
      message: data['message'],
      status: data['status'],
    );
  }
}