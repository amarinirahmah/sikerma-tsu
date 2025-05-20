class User {
  String name;
  String email;
  String password;
  String role;
  String token;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email: json['email'],
    password: json['password'],
    role: json['role'],
    token: json['token'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    'token': token,
  };
}
