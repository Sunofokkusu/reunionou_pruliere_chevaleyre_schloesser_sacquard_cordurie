class User {
  User({
    required this.name,
    required this.email,
  });

  String name;
  String email;

  static User fromJson(data) {
    return User(
      name: data['name'],
      email: data['mail'],
    );
  }
}