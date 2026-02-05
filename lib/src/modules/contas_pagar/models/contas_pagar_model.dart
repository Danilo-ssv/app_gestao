import 'dart:convert';

class ContasPagarModel {
  final String id;
  final String dataVencimento;
  final String nomeFornecedores;
  final String nomeDespesas;
  final String descricao;
  final String valor;
  final String status;
  final String nomeStatus;
  final String color;

  ContasPagarModel({
    required this.id,
    required this.dataVencimento,
    required this.nomeFornecedores,
    required this.nomeDespesas,
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
      'nomeFornecedores': nomeFornecedores,
      'nomeDespesas': nomeDespesas,
      'descricao': descricao,
      'valor': valor,
      'status': status,
      'nomeStatus': nomeStatus,
      'color': color,
    };
  }

  factory ContasPagarModel.fromMap(Map<String, dynamic> map) {
    return ContasPagarModel(
      id: map['id'] as String,
      dataVencimento: map['dataVencimento'] as String,
      nomeFornecedores: map['nomeFornecedores'] as String,
      nomeDespesas: map['nomeDespesas'] as String,
      descricao: map['descricao'] as String,
      valor: map['valor'] as String,
      status: map['status'] as String,
      nomeStatus: map['nomeStatus'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContasPagarModel.fromJson(String source) => ContasPagarModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
