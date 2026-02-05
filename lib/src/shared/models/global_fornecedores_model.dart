import 'dart:convert';

class GlobalFornecedoresModel {
  final String id;
  final String nome;

  GlobalFornecedoresModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory GlobalFornecedoresModel.fromMap(Map<String, dynamic> map) {
    return GlobalFornecedoresModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalFornecedoresModel.fromJson(String source) => GlobalFornecedoresModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
