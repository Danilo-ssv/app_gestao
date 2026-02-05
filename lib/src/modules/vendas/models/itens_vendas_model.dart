import 'dart:convert';

class ItensVendasModel {
  final String id;
  final String idProdutos;
  final String nomeProdutos;
  final String quantidade;
  final String valor;
  final bool isSelect;
  final bool deleting;

  ItensVendasModel({
    required this.id,
    required this.idProdutos,
    required this.nomeProdutos,
    required this.quantidade,
    required this.valor,
    required this.isSelect,
    required this.deleting,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idProdutos': idProdutos,
      'nomeProdutos': nomeProdutos,
      'quantidade': quantidade,
      'valor': valor,
      'isSelect': isSelect,
      'deleting': deleting,
    };
  }

  factory ItensVendasModel.fromMap(Map<String, dynamic> map) {
    return ItensVendasModel(
      id: map['id'] as String,
      idProdutos: map['idProdutos'] as String,
      nomeProdutos: map['nomeProdutos'] as String,
      quantidade: map['quantidade'] as String,
      valor: map['valor'] as String,
      isSelect: map['isSelect'] as bool,
      deleting: map['deleting'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItensVendasModel.fromJson(String source) => ItensVendasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
