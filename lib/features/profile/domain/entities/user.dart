class User {
  final String title;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String mobileNo;
  final String? profileImageUrl;

  User({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.mobileNo,
    this.profileImageUrl,
  });
}