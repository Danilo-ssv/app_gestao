import 'dart:convert';

class GlobalMarcasProdutosModel {
  final String id;
  final String nome;

  GlobalMarcasProdutosModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory GlobalMarcasProdutosModel.fromMap(Map<String, dynamic> map) {
    return GlobalMarcasProdutosModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalMarcasProdutosModel.fromJson(String source) => GlobalMarcasProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
