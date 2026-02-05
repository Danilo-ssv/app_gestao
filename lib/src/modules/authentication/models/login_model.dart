import 'dart:convert';

class LoginModel {
  final String email;
  final String senha;

  LoginModel({
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'senha': senha,
    };
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) => LoginModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
