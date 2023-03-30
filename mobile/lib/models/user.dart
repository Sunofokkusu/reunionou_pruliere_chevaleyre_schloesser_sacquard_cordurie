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
    print(data);
    return User(
      id: data['id'],
      name: data['name'],
      email: data['mail'],
    );
  }
}