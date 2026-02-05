import 'dart:convert';

class ClientesModel {
  final String id;
  final String nome;
  final String celular;
  final String email;

  ClientesModel({
    required this.id,
    required this.nome,
    required this.celular,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'celular': celular,
      'email': email,
    };
  }

  factory ClientesModel.fromMap(Map<String, dynamic> map) {
    return ClientesModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      celular: map['celular'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientesModel.fromJson(String source) =>
      ClientesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
