class User {
  final String name;
  final String email;

  User(this.name, this.email);

   @override
  String toString() => 'User { name: $name, email: $email}';
}
