import 'dart:convert';

class VendasModel {
  final String id;
  final String nomeClientes;
  final String valorTotal;
  final String dataModificacao;
  final String status;

  VendasModel({
    required this.id,
    required this.nomeClientes,
    required this.valorTotal,
    required this.dataModificacao,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nomeClientes': nomeClientes,
      'valorTotal': valorTotal,
      'dataModificacao': dataModificacao,
      'status': status,
    };
  }

  factory VendasModel.fromMap(Map<String, dynamic> map) {
    return VendasModel(
      id: map['id'] as String,
      nomeClientes: map['nomeClientes'] as String,
      valorTotal: map['valorTotal'] as String,
      dataModificacao: map['dataModificacao'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VendasModel.fromJson(String source) => VendasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
