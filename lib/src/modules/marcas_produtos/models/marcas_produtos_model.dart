import 'dart:convert';

class MarcasProdutosModel {
  final String id;
  final String nome;

  MarcasProdutosModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory MarcasProdutosModel.fromMap(Map<String, dynamic> map) {
    return MarcasProdutosModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MarcasProdutosModel.fromJson(String source) => MarcasProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
