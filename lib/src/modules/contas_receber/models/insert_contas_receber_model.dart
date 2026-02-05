import 'dart:convert';

class InsertContasReceberModel {
  final String id;
  final String idClientes;
  final String nomeClientes;
  final String dataEmissao;
  final String dataVencimento;
  final String descricao;
  final String valor;

  InsertContasReceberModel({
    required this.id,
    required this.idClientes,
    required this.nomeClientes,
    required this.dataEmissao,
    required this.dataVencimento,
    required this.descricao,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idClientes': idClientes,
      'nomeClientes': nomeClientes,
      'dataEmissao': dataEmissao,
      'dataVencimento': dataVencimento,
      'descricao': descricao,
      'valor': valor,
    };
  }

  factory InsertContasReceberModel.fromMap(Map<String, dynamic> map) {
    return InsertContasReceberModel(
      id: map['id'] as String,
      idClientes: map['idClientes'] as String,
      nomeClientes: map['nomeClientes'] as String,
      dataEmissao: map['dataEmissao'] as String,
      dataVencimento: map['dataVencimento'] as String,
      descricao: map['descricao'] as String,
      valor: map['valor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertContasReceberModel.fromJson(String source) => InsertContasReceberModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
