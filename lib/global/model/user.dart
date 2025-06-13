class User {
  String email;
  String password;
  String rePassword;
  String fullName;

  User({
    required this.email,
    required this.password,
    required this.rePassword,
    required this.fullName,
  });

  // To create a User object from a map (useful when parsing JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      rePassword: json['re_password'],
      fullName: json['full_name'],
    );
  }

  // To convert a User object to a map (useful for sending data in API requests)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      're_password': rePassword,
      'full_name': fullName,
    };
  }

  // Validate if the password and rePassword match
  String validate() {
    if (password != rePassword) {
      return 'Passwords do not match';
    }
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      return 'All fields are required';
    }
    return 'User data is valid';
  }
}
