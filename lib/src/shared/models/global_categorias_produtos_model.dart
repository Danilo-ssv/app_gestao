import 'dart:convert';

class GlobalCategoriasProdutosModel {
  final String id;
  final String nome;

  GlobalCategoriasProdutosModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory GlobalCategoriasProdutosModel.fromMap(Map<String, dynamic> map) {
    return GlobalCategoriasProdutosModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalCategoriasProdutosModel.fromJson(String source) => GlobalCategoriasProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
