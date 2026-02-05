import 'dart:convert';

import 'package:app_gestao/src/shared/models/image_model.dart';

class ListaCategoriasVendasModel {
  final String id;
  final String nome;
  final List<ProdutosListaCategoriasVendasModel> produtos;

  ListaCategoriasVendasModel({
    required this.id,
    required this.nome,
    required this.produtos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'produtos': produtos.map((x) => x.toMap()).toList(),
    };
  }

  factory ListaCategoriasVendasModel.fromMap(Map<String, dynamic> map) {
    return ListaCategoriasVendasModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      produtos: List<ProdutosListaCategoriasVendasModel>.from(
        (map['produtos'] as List<dynamic>).map<ProdutosListaCategoriasVendasModel>(
          (x) => ProdutosListaCategoriasVendasModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListaCategoriasVendasModel.fromJson(String source) => ListaCategoriasVendasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProdutosListaCategoriasVendasModel {
  final String id;
  final String nome;
  final String preco;
  String estoque;
  final ImageModel? image;

  ProdutosListaCategoriasVendasModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.estoque,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'preco': preco,
      'estoque': estoque,
      'image': image,
    };
  }

  factory ProdutosListaCategoriasVendasModel.fromMap(Map<String, dynamic> map) {
    return ProdutosListaCategoriasVendasModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      preco: map['preco'] as String,
      estoque: map['estoque'] as String,
      image: map['image'] as ImageModel?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutosListaCategoriasVendasModel.fromJson(String source) =>
      ProdutosListaCategoriasVendasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
