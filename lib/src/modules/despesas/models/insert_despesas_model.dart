import 'dart:convert';

class InsertDespesasModel {
  final String id;
  final String nome;

  InsertDespesasModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory InsertDespesasModel.fromMap(Map<String, dynamic> map) {
    return InsertDespesasModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertDespesasModel.fromJson(String source) => InsertDespesasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
