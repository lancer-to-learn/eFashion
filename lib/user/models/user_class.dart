class UserClass {
  final int id;
  final String email;
  final String password;
  final String address;
  final String city;
  final String state;
  final String postalcode;
  final String phone;

  const UserClass(
    {
    required this.id,
    required this.email,
    required this.password,
    required this.address,
    required this.city,
    required this.state,
    required this.postalcode,
    required this.phone,
    }
  );
  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
   Map<String, Object?> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'address':address,
      'city':city,
      'state':state,
      'postalcode':postalcode,
      'phone':phone
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password, address: $address, city: $city, state: $state, postalcode: $postalcode, phone: $phone}';
  }
}