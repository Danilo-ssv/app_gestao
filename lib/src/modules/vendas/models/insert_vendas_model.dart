import 'dart:convert';

import 'package:app_gestao/src/modules/vendas/models/itens_vendas_model.dart';

class InsertVendasModel {
  final String id;
  final String idClientes;
  final String nomeClientes;
  final String valorTotal;
  final List<ItensVendasModel> listaItensVendas;

  InsertVendasModel({
    required this.id,
    required this.idClientes,
    required this.nomeClientes,
    required this.valorTotal,
    required this.listaItensVendas,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idClientes': idClientes,
      'nomeClientes': nomeClientes,
      'valorTotal': valorTotal,
      'listaItensVendas': listaItensVendas.map((x) => x.toMap()).toList(),
    };
  }

  factory InsertVendasModel.fromMap(Map<String, dynamic> map) {
    return InsertVendasModel(
      id: map['id'] as String,
      idClientes: map['idClientes'] as String,
      nomeClientes: map['nomeClientes'] as String,
      valorTotal: map['valorTotal'] as String,
      listaItensVendas: List<ItensVendasModel>.from(
        (map['listaItensVendas'] as List<dynamic>).map<ItensVendasModel>(
          (x) => ItensVendasModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertVendasModel.fromJson(String source) => InsertVendasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
