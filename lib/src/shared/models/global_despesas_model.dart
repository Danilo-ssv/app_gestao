import 'dart:convert';

class GlobalDespesasModel {
  final String id;
  final String nome;

  GlobalDespesasModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory GlobalDespesasModel.fromMap(Map<String, dynamic> map) {
    return GlobalDespesasModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalDespesasModel.fromJson(String source) => GlobalDespesasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
