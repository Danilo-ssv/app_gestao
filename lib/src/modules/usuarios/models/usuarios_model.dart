import 'dart:convert';

class UsuariosModel {
  final String id;
  final String email;
  final String root;

  UsuariosModel({
    required this.id,
    required this.email,
    required this.root,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'root': root,
    };
  }

  factory UsuariosModel.fromMap(Map<String, dynamic> map) {
    return UsuariosModel(
      id: map['id'] as String,
      email: map['email'] as String,
      root: map['root'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuariosModel.fromJson(String source) => UsuariosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
