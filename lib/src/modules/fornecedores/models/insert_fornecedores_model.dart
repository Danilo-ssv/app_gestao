import 'dart:convert';

enum FornecedoresEntidade { $1, $2 }
extension FornecedoresEntidadeExtension on FornecedoresEntidade {
  FornecedoresEntidade formatToEnum(String value) => FornecedoresEntidade.values.firstWhere(
        (e) => e.name == '\$$value',
        orElse: () => FornecedoresEntidade.$1,
      );
  String formatToString() => name.split('\$').last;
}

class InsertFornecedoresModel {
  final String id;
  final String nome;
  final FornecedoresEntidade entidade;
  final String doc;
  final String celular;
  final String email;

  InsertFornecedoresModel({
    required this.id,
    required this.nome,
    required this.entidade,
    required this.doc,
    required this.celular,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'entidade': entidade.formatToString(),
      'doc': doc,
      'celular': celular,
      'email': email,
    };
  }

  factory InsertFornecedoresModel.fromMap(Map<String, dynamic> map) {
    return InsertFornecedoresModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      entidade: FornecedoresEntidade.$1.formatToEnum(map['entidade'] as String),
      doc: map['doc'] as String,
      celular: map['celular'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertFornecedoresModel.fromJson(String source) => InsertFornecedoresModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
