class User {
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  String id;
  String name;
  String email;

  static User fromJson(data) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['mail'],
    );
  }

  static User fromEventJson(data) {
    return User(
      id: data['id'],
      name: data['name'],
      email: data['mail'],
    );
  }
}
