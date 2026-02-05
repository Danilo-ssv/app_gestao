import 'dart:convert';

class GlobalClientesModel {
  final String id;
  final String nome;

  GlobalClientesModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory GlobalClientesModel.fromMap(Map<String, dynamic> map) {
    return GlobalClientesModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalClientesModel.fromJson(String source) => GlobalClientesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
