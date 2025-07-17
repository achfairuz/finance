class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? token; // ✅ ubah jadi nullable

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      token: json['token'], // token boleh null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'token': token,
    };
  }
}
