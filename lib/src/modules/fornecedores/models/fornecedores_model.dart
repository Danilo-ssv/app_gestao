import 'dart:convert';

class FornecedoresModel {
  final String id;
  final String nome;

  FornecedoresModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory FornecedoresModel.fromMap(Map<String, dynamic> map) {
    return FornecedoresModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FornecedoresModel.fromJson(String source) => FornecedoresModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
