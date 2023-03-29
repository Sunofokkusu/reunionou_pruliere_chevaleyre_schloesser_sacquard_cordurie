class Comment {
  Comment({
    required this.name,
    required this.email,
    required this.text,
    this.response,
  });

  String name;
  String email;
  String text = "";
  int? response;
  DateTime createdAt = DateTime.now();
}
