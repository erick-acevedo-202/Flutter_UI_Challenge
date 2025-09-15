class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password; // encriptar
  final String avatarPath;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatarPath': avatarPath,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      avatarPath: map['avatarPath'],
    );
  }
}
