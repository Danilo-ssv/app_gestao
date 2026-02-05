import 'dart:convert';

class InsertUsuariosModel {
  final String id;
  final String email;
  final String senha;
  final List<({String id, String permissao, bool delete})> listaPermissoes;

  InsertUsuariosModel({
    required this.id,
    required this.email,
    required this.senha,
    required this.listaPermissoes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'senha': senha,
      'listaPermissoes': listaPermissoes.map((e) => {'id': e.id, 'permissao': e.permissao, 'delete': e.delete}).toList(),
    };
  }

  factory InsertUsuariosModel.fromMap(Map<String, dynamic> map) {
    return InsertUsuariosModel(
      id: map['id'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      listaPermissoes: map['listaPermissoes'] as List<({String id, String permissao, bool delete})>,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertUsuariosModel.fromJson(String source) => InsertUsuariosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
