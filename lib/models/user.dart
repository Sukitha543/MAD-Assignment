class User {
  final String firstName;
  final String lastName;
  final String shippingAddress;
  final String emailAddress;
  final int contactNumber;
  final String username;
  final String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.shippingAddress,
    required this.contactNumber,
    required this.username,
    required this.password,
  });
}
