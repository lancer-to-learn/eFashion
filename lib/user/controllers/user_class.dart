class UserClass {
  final int id;
  final String email;
  final String password;

  const UserClass(
    {
    required this.id,
    required this.email,
    required this.password,
    }
  );
  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
   Map<String, Object?> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password}';
  }
}