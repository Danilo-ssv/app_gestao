import 'dart:convert';

class GlobalMunicipiosModel {
  final String id;
  final String codigo;
  final String nome;
  final String uf;

  GlobalMunicipiosModel({
    required this.id,
    required this.codigo,
    required this.nome,
    required this.uf,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'codigo': codigo,
      'nome': nome,
      'uf': uf,
    };
  }

  factory GlobalMunicipiosModel.fromMap(Map<String, dynamic> map) {
    return GlobalMunicipiosModel(
      id: map['id'] as String,
      codigo: map['codigo'] as String,
      nome: map['nome'] as String,
      uf: map['uf'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalMunicipiosModel.fromJson(String source) => GlobalMunicipiosModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
