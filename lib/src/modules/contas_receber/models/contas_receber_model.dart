import 'dart:convert';

class ContasReceberModel {
  final String id;
  final String dataVencimento;
  final String nomeClientes;
  final String descricao;
  final String valor;
  final String status;
  final String nomeStatus;
  final String color;

  ContasReceberModel({
    required this.id,
    required this.dataVencimento,
    required this.nomeClientes,
    required this.descricao,
    required this.valor,
    required this.status,
    required this.nomeStatus,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataVencimento': dataVencimento,
      'nomeClientes': nomeClientes,
      'descricao': descricao,
      'valor': valor,
      'status': status,
      'nomeStatus': nomeStatus,
      'color': color,
    };
  }

  factory ContasReceberModel.fromMap(Map<String, dynamic> map) {
    return ContasReceberModel(
      id: map['id'] as String,
      dataVencimento: map['dataVencimento'] as String,
      nomeClientes: map['nomeClientes'] as String,
      descricao: map['descricao'] as String,
      valor: map['valor'] as String,
      status: map['status'] as String,
      nomeStatus: map['nomeStatus'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContasReceberModel.fromJson(String source) => ContasReceberModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
