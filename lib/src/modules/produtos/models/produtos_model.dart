import 'dart:convert';

class ProdutosModel {
  final String id;
  final String codigo;
  final String nome;
  final String preco;
  final String estoque;

  ProdutosModel({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.preco,
    required this.estoque,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'codigo': codigo,
      'nome': nome,
      'preco': preco,
      'estoque': estoque,
    };
  }

  factory ProdutosModel.fromMap(Map<String, dynamic> map) {
    return ProdutosModel(
      id: map['id'] as String,
      codigo: map['codigo'] as String,
      nome: map['nome'] as String,
      preco: map['preco'] as String,
      estoque: map['estoque'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutosModel.fromJson(String source) => ProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
