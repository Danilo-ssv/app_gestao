import 'dart:convert';

enum ClientesEstadoCivil { $1, $2, $3, $4, $5 }
extension ClientesEstadoCivilExtension on ClientesEstadoCivil {
  ClientesEstadoCivil formatToEnum(String value) => ClientesEstadoCivil.values.firstWhere(
        (e) => e.name == '\$$value',
        orElse: () => ClientesEstadoCivil.$1,
      );
  String formatToString() => name.split('\$').last;
}

enum ClientesGenero { $1, $2, $3 }
extension ClientesGeneroExtension on ClientesGenero {
  ClientesGenero formatToEnum(String value) => ClientesGenero.values.firstWhere(
        (e) => e.name == '\$$value',
        orElse: () => ClientesGenero.$1,
      );
  String formatToString() => name.split('\$').last;
}

enum ClientesEntidade { $1, $2 }
extension ClientesEntidadeExtension on ClientesEntidade {
  ClientesEntidade formatToEnum(String value) => ClientesEntidade.values.firstWhere(
        (e) => e.name == '\$$value',
        orElse: () => ClientesEntidade.$1,
      );
  String formatToString() => name.split('\$').last;
}

class InsertClientesModel {
  final String id;
  final String nome;
  final ClientesEstadoCivil estadoCivil;
  final ClientesGenero genero;
  final ClientesEntidade entidade;
  final String aniversario;
  final String doc;
  final String rg;
  final String celular;
  final String email;
  final String cep;
  final String endereco;
  final String numero;
  final String idMunicipios;
  final String nomeMunicipios;
  final String obs;

  InsertClientesModel({
    required this.id,
    required this.nome,
    required this.estadoCivil,
    required this.genero,
    required this.entidade,
    required this.aniversario,
    required this.doc,
    required this.rg,
    required this.celular,
    required this.email,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.idMunicipios,
    required this.nomeMunicipios,
    required this.obs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'estadoCivil': estadoCivil.formatToString(),
      'genero': genero.formatToString(),
      'entidade': entidade.formatToString(),
      'aniversario': aniversario,
      'doc': doc,
      'rg': rg,
      'celular': celular,
      'email': email,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'idMunicipios': idMunicipios,
      'nomeMunicipios': nomeMunicipios,
      'obs': obs,
    };
  }

  factory InsertClientesModel.fromMap(Map<String, dynamic> map) {
    return InsertClientesModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      estadoCivil: ClientesEstadoCivil.$1.formatToEnum(map['estadoCivil'] as String),
      genero: ClientesGenero.$1.formatToEnum(map['genero'] as String),
      entidade: ClientesEntidade.$1.formatToEnum(map['entidade'] as String),
      aniversario: map['aniversario'] as String,
      doc: map['doc'] as String,
      rg: map['rg'] as String,
      celular: map['celular'] as String,
      email: map['email'] as String,
      cep: map['cep'] as String,
      endereco: map['endereco'] as String,
      numero: map['numero'] as String,
      idMunicipios: map['idMunicipios'] as String,
      nomeMunicipios: map['nomeMunicipios'] as String,
      obs: map['obs'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InsertClientesModel.fromJson(String source) => InsertClientesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
