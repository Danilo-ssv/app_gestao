import 'dart:convert';

class InsertMarcasProdutosModel {
  final String id;
  final String nome;

  InsertMarcasProdutosModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory InsertMarcasProdutosModel.fromMap(Map<String, dynamic> map) {
    return InsertMarcasProdutosModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertMarcasProdutosModel.fromJson(String source) => InsertMarcasProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
