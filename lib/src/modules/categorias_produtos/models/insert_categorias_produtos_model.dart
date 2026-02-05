import 'dart:convert';

class InsertCategoriasProdutosModel {
  final String id;
  final String nome;

  InsertCategoriasProdutosModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory InsertCategoriasProdutosModel.fromMap(Map<String, dynamic> map) {
    return InsertCategoriasProdutosModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertCategoriasProdutosModel.fromJson(String source) => InsertCategoriasProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
