import 'dart:convert';

import 'package:app_gestao/src/shared/models/file_model.dart';

enum ProdutosGenero { $1, $2 }
extension ProdutosGeneroExtension on ProdutosGenero {
  ProdutosGenero formatToEnum(String value) => ProdutosGenero.values.firstWhere(
        (e) => e.name == '\$$value',
        orElse: () => ProdutosGenero.$1,
      );
  String formatToString() => name.split('\$').last;
}

class InsertProdutosModel {
  final String id;
  final String codigoBarra;
  final String codigo;
  final String nome;
  final String descricao;
  final String preco;
  final String custo;
  final String estoque;
  final String idMarcasProdutos;
  final String nomeMarcasProdutos;
  final String idCategoriasProdutos;
  final String nomeCategoriasProdutos;
  final String alertaEstoqueMinimo;
  final ProdutosGenero genero;
  final FileModel? image;

  InsertProdutosModel({
    required this.id,
    required this.codigoBarra,
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.custo,
    required this.estoque,
    required this.idMarcasProdutos,
    required this.nomeMarcasProdutos,
    required this.idCategoriasProdutos,
    required this.nomeCategoriasProdutos,
    required this.alertaEstoqueMinimo,
    required this.genero,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'codigoBarra': codigoBarra,
      'codigo': codigo,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'custo': custo,
      'estoque': estoque,
      'idMarcasProdutos': idMarcasProdutos,
      'nomeMarcasProdutos': nomeMarcasProdutos,
      'idCategoriasProdutos': idCategoriasProdutos,
      'nomeCategoriasProdutos': nomeCategoriasProdutos,
      'alertaEstoqueMinimo': alertaEstoqueMinimo,
      'genero': genero.formatToString(),
    };
  }

  factory InsertProdutosModel.fromMap(Map<String, dynamic> map) {
    return InsertProdutosModel(
      id: map['id'] as String,
      codigoBarra: map['codigoBarra'] as String,
      codigo: map['codigo'] as String,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String,
      preco: map['preco'] as String,
      custo: map['custo'] as String,
      estoque: map['estoque'] as String,
      idMarcasProdutos: map['idMarcasProdutos'] as String,
      nomeMarcasProdutos: map['nomeMarcasProdutos'] as String,
      idCategoriasProdutos: map['idCategoriasProdutos'] as String,
      nomeCategoriasProdutos: map['nomeCategoriasProdutos'] as String,
      alertaEstoqueMinimo: map['alertaEstoqueMinimo'] as String,
      genero: ProdutosGenero.$1.formatToEnum(map['genero'] as String),
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertProdutosModel.fromJson(String source) => InsertProdutosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
