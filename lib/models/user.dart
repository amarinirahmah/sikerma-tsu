class User {
  int id;
  String name;
  String email;
  String? password;
  String role;
  String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    role: json['role'] ?? '',
    token: json['token'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    if (password != null) 'password': password,
    'role': role,
    if (token != null) 'token': token,
  };
}
