import 'dart:convert';

class SessionUserModel {
  final String id;
  final String idAssinatura;
  final String nome;
  final String email;
  final bool root;
  final bool adm;
  final PermissoesUserModel permissoes;

  SessionUserModel({
    required this.id,
    required this.idAssinatura,
    required this.nome,
    required this.email,
    required this.root,
    required this.adm,
    required this.permissoes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idAssinatura': idAssinatura,
      'nome': nome,
      'email': email,
      'root': root,
      'adm': adm,
      'permissoes': permissoes.toMap(),
    };
  }

  factory SessionUserModel.fromMap(Map<String, dynamic> map) {
    return SessionUserModel(
      id: map['id'] as String,
      idAssinatura: map['idAssinatura'] as String,
      nome: map['nome'] as String,
      email: map['email'] as String,
      root: map['root'] as bool,
      adm: map['adm'] as bool,
      permissoes: PermissoesUserModel.fromMap(map['permissoes'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionUserModel.fromJson(String source) => SessionUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PermissoesUserModel {
  final bool clientesRead;
  final bool clientesInsert;
  final bool clientesUpdate;
  final bool clientesDelete;
  final bool produtosRead;
  final bool produtosInsert;
  final bool produtosUpdate;
  final bool produtosDelete;
  final bool produtosInsertBaixaEstoque;
  final bool agendaRead;
  final bool agendaInsert;
  final bool agendaUpdate;
  final bool agendaDelete;
  final bool usuariosRead;
  final bool usuariosInsert;
  final bool usuariosUpdate;
  final bool usuariosDelete;
  final bool fornecedoresRead;
  final bool fornecedoresInsert;
  final bool fornecedoresUpdate;
  final bool fornecedoresDelete;
  final bool categoriasProdutosRead;
  final bool categoriasProdutosInsert;
  final bool categoriasProdutosUpdate;
  final bool categoriasProdutosDelete;
  final bool despesasRead;
  final bool despesasInsert;
  final bool despesasUpdate;
  final bool despesasDelete;
  final bool contasPagarRead;
  final bool contasPagarInsert;
  final bool contasPagarUpdate;
  final bool contasPagarDelete;
  final bool contasPagarWriteOff;
  final bool contasPagarParcelling;
  final bool contasReceberRead;
  final bool contasReceberInsert;
  final bool contasReceberUpdate;
  final bool contasReceberDelete;
  final bool contasReceberWriteOff;
  final bool contasReceberParcelling;
  final bool vendasRead;
  final bool vendasInsert;
  final bool vendasUpdate;
  final bool vendasDelete;
  final bool vendasFinalize;
  final bool hfEscolasRead;
  final bool hfEscolasInsert;
  final bool hfEscolasUpdate;
  final bool hfEscolasDelete;
  final bool hfContratosRead;
  final bool hfContratosInsert;
  final bool hfContratosUpdate;
  final bool hfContratosDelete;
  final bool hfContratosWriteOff;
  final bool marcasProdutosRead;
  final bool marcasProdutosInsert;
  final bool marcasProdutosUpdate;
  final bool marcasProdutosDelete;

  PermissoesUserModel({
    required this.clientesRead,
    required this.clientesInsert,
    required this.clientesUpdate,
    required this.clientesDelete,
    required this.produtosRead,
    required this.produtosInsert,
    required this.produtosUpdate,
    required this.produtosDelete,
    required this.produtosInsertBaixaEstoque,
    required this.agendaRead,
    required this.agendaInsert,
    required this.agendaUpdate,
    required this.agendaDelete,
    required this.usuariosRead,
    required this.usuariosInsert,
    required this.usuariosUpdate,
    required this.usuariosDelete,
    required this.fornecedoresRead,
    required this.fornecedoresInsert,
    required this.fornecedoresUpdate,
    required this.fornecedoresDelete,
    required this.categoriasProdutosRead,
    required this.categoriasProdutosInsert,
    required this.categoriasProdutosUpdate,
    required this.categoriasProdutosDelete,
    required this.despesasRead,
    required this.despesasInsert,
    required this.despesasUpdate,
    required this.despesasDelete,
    required this.contasPagarRead,
    required this.contasPagarInsert,
    required this.contasPagarUpdate,
    required this.contasPagarDelete,
    required this.contasPagarWriteOff,
    required this.contasPagarParcelling,
    required this.contasReceberRead,
    required this.contasReceberInsert,
    required this.contasReceberUpdate,
    required this.contasReceberDelete,
    required this.contasReceberWriteOff,
    required this.contasReceberParcelling,
    required this.vendasRead,
    required this.vendasInsert,
    required this.vendasUpdate,
    required this.vendasDelete,
    required this.vendasFinalize,
    required this.hfEscolasRead,
    required this.hfEscolasInsert,
    required this.hfEscolasUpdate,
    required this.hfEscolasDelete,
    required this.hfContratosRead,
    required this.hfContratosInsert,
    required this.hfContratosUpdate,
    required this.hfContratosDelete,
    required this.hfContratosWriteOff,
    required this.marcasProdutosRead,
    required this.marcasProdutosInsert,
    required this.marcasProdutosUpdate,
    required this.marcasProdutosDelete,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientesRead': clientesRead,
      'clientesInsert': clientesInsert,
      'clientesUpdate': clientesUpdate,
      'clientesDelete': clientesDelete,
      'produtosRead': produtosRead,
      'produtosInsert': produtosInsert,
      'produtosUpdate': produtosUpdate,
      'produtosDelete': produtosDelete,
      'produtosInsertBaixaEstoque': produtosInsertBaixaEstoque,
      'agendaRead': agendaRead,
      'agendaInsert': agendaInsert,
      'agendaUpdate': agendaUpdate,
      'agendaDelete': agendaDelete,
      'usuariosRead': usuariosRead,
      'usuariosInsert': usuariosInsert,
      'usuariosUpdate': usuariosUpdate,
      'usuariosDelete': usuariosDelete,
      'fornecedoresRead': fornecedoresRead,
      'fornecedoresInsert': fornecedoresInsert,
      'fornecedoresUpdate': fornecedoresUpdate,
      'fornecedoresDelete': fornecedoresDelete,
      'categoriasProdutosRead': categoriasProdutosRead,
      'categoriasProdutosInsert': categoriasProdutosInsert,
      'categoriasProdutosUpdate': categoriasProdutosUpdate,
      'categoriasProdutosDelete': categoriasProdutosDelete,
      'despesasRead': despesasRead,
      'despesasInsert': despesasInsert,
      'despesasUpdate': despesasUpdate,
      'despesasDelete': despesasDelete,
      'contasPagarRead': contasPagarRead,
      'contasPagarInsert': contasPagarInsert,
      'contasPagarUpdate': contasPagarUpdate,
      'contasPagarDelete': contasPagarDelete,
      'contasPagarWriteOff': contasPagarWriteOff,
      'contasPagarParcelling': contasPagarParcelling,
      'contasReceberRead': contasReceberRead,
      'contasReceberInsert': contasReceberInsert,
      'contasReceberUpdate': contasReceberUpdate,
      'contasReceberDelete': contasReceberDelete,
      'contasReceberWriteOff': contasReceberWriteOff,
      'contasReceberParcelling': contasReceberParcelling,
      'vendasRead': vendasRead,
      'vendasInsert': vendasInsert,
      'vendasUpdate': vendasUpdate,
      'vendasDelete': vendasDelete,
      'vendasFinalize': vendasFinalize,
      'hfEscolasRead': hfEscolasRead,
      'hfEscolasInsert': hfEscolasInsert,
      'hfEscolasUpdate': hfEscolasUpdate,
      'hfEscolasDelete': hfEscolasDelete,
      'hfContratosRead': hfContratosRead,
      'hfContratosInsert': hfContratosInsert,
      'hfContratosUpdate': hfContratosUpdate,
      'hfContratosDelete': hfContratosDelete,
      'hfContratosWriteOff': hfContratosWriteOff,
      'marcasProdutosRead': marcasProdutosRead,
      'marcasProdutosInsert': marcasProdutosInsert,
      'marcasProdutosUpdate': marcasProdutosUpdate,
      'marcasProdutosDelete': marcasProdutosDelete,
    };
  }

  factory PermissoesUserModel.fromMap(Map<String, dynamic> map) {
    return PermissoesUserModel(
      clientesRead: map['clientesRead'] as bool,
      clientesInsert: map['clientesInsert'] as bool,
      clientesUpdate: map['clientesUpdate'] as bool,
      clientesDelete: map['clientesDelete'] as bool,
      produtosRead: map['produtosRead'] as bool,
      produtosInsert: map['produtosInsert'] as bool,
      produtosUpdate: map['produtosUpdate'] as bool,
      produtosDelete: map['produtosDelete'] as bool,
      produtosInsertBaixaEstoque: map['produtosInsertBaixaEstoque'] as bool,
      agendaRead: map['agendaRead'] as bool,
      agendaInsert: map['agendaInsert'] as bool,
      agendaUpdate: map['agendaUpdate'] as bool,
      agendaDelete: map['agendaDelete'] as bool,
      usuariosRead: map['usuariosRead'] as bool,
      usuariosInsert: map['usuariosInsert'] as bool,
      usuariosUpdate: map['usuariosUpdate'] as bool,
      usuariosDelete: map['usuariosDelete'] as bool,
      fornecedoresRead: map['fornecedoresRead'] as bool,
      fornecedoresInsert: map['fornecedoresInsert'] as bool,
      fornecedoresUpdate: map['fornecedoresUpdate'] as bool,
      fornecedoresDelete: map['fornecedoresDelete'] as bool,
      categoriasProdutosRead: map['categoriasProdutosRead'] as bool,
      categoriasProdutosInsert: map['categoriasProdutosInsert'] as bool,
      categoriasProdutosUpdate: map['categoriasProdutosUpdate'] as bool,
      categoriasProdutosDelete: map['categoriasProdutosDelete'] as bool,
      despesasRead: map['despesasRead'] as bool,
      despesasInsert: map['despesasInsert'] as bool,
      despesasUpdate: map['despesasUpdate'] as bool,
      despesasDelete: map['despesasDelete'] as bool,
      contasPagarRead: map['contasPagarRead'] as bool,
      contasPagarInsert: map['contasPagarInsert'] as bool,
      contasPagarUpdate: map['contasPagarUpdate'] as bool,
      contasPagarDelete: map['contasPagarDelete'] as bool,
      contasPagarWriteOff: map['contasPagarWriteOff'] as bool,
      contasPagarParcelling: map['contasPagarParcelling'] as bool,
      contasReceberRead: map['contasReceberRead'] as bool,
      contasReceberInsert: map['contasReceberInsert'] as bool,
      contasReceberUpdate: map['contasReceberUpdate'] as bool,
      contasReceberDelete: map['contasReceberDelete'] as bool,
      contasReceberWriteOff: map['contasReceberWriteOff'] as bool,
      contasReceberParcelling: map['contasReceberParcelling'] as bool,
      vendasRead: map['vendasRead'] as bool,
      vendasInsert: map['vendasInsert'] as bool,
      vendasUpdate: map['vendasUpdate'] as bool,
      vendasDelete: map['vendasDelete'] as bool,
      vendasFinalize: map['vendasFinalize'] as bool,
      hfEscolasRead: map['hfEscolasRead'] as bool,
      hfEscolasInsert: map['hfEscolasInsert'] as bool,
      hfEscolasUpdate: map['hfEscolasUpdate'] as bool,
      hfEscolasDelete: map['hfEscolasDelete'] as bool,
      hfContratosRead: map['hfContratosRead'] as bool,
      hfContratosInsert: map['hfContratosInsert'] as bool,
      hfContratosUpdate: map['hfContratosUpdate'] as bool,
      hfContratosDelete: map['hfContratosDelete'] as bool,
      hfContratosWriteOff: map['hfContratosWriteOff'] as bool,
      marcasProdutosRead: map['marcasProdutosRead'] as bool,
      marcasProdutosInsert: map['marcasProdutosInsert'] as bool,
      marcasProdutosUpdate: map['marcasProdutosUpdate'] as bool,
      marcasProdutosDelete: map['marcasProdutosDelete'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissoesUserModel.fromJson(String source) => PermissoesUserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
