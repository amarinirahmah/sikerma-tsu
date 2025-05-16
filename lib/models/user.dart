class User {
  String name;
  String email;
  String password;
  String role;
  String access_token;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.access_token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email: json['email'],
    password: json['password'],
    role: json['role'],
    access_token: json['access_token'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    'access_token': access_token,
  };
}
