import 'dart:convert';

class DespesasModel {
  final String id;
  final String nome;

  DespesasModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory DespesasModel.fromMap(Map<String, dynamic> map) {
    return DespesasModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DespesasModel.fromJson(String source) => DespesasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
