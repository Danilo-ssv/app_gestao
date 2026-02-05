import 'dart:convert';

class CategoriasProdutosModel {
  final String id;
  final String nome;

  CategoriasProdutosModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory CategoriasProdutosModel.fromMap(Map<String, dynamic> map) {
    return CategoriasProdutosModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriasProdutosModel.fromJson(String source) => CategoriasProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
