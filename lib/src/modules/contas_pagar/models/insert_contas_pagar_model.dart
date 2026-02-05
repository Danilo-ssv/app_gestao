import 'dart:convert';

class InsertContasPagarModel {
  final String id;
  final String idFornecedores;
  final String nomeFornecedores;
  final String dataEmissao;
  final String dataVencimento;
  final String idDespesas;
  final String nomeDespesas;
  final String descricao;
  final String valor;

  InsertContasPagarModel({
    required this.id,
    required this.idFornecedores,
    required this.nomeFornecedores,
    required this.dataEmissao,
    required this.dataVencimento,
    required this.idDespesas,
    required this.nomeDespesas,
    required this.descricao,
    required this.valor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idFornecedores': idFornecedores,
      'nomeFornecedores': nomeFornecedores,
      'dataEmissao': dataEmissao,
      'dataVencimento': dataVencimento,
      'idDespesas': idDespesas,
      'nomeDespesas': nomeDespesas,
      'descricao': descricao,
      'valor': valor,
    };
  }

  factory InsertContasPagarModel.fromMap(Map<String, dynamic> map) {
    return InsertContasPagarModel(
      id: map['id'] as String,
      idFornecedores: map['idFornecedores'] as String,
      nomeFornecedores: map['nomeFornecedores'] as String,
      dataEmissao: map['dataEmissao'] as String,
      dataVencimento: map['dataVencimento'] as String,
      idDespesas: map['idDespesas'] as String,
      nomeDespesas: map['nomeDespesas'] as String,
      descricao: map['descricao'] as String,
      valor: map['valor'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertContasPagarModel.fromJson(String source) => InsertContasPagarModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
