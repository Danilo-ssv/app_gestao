import 'dart:convert';

class GlobalHfEscolasModel {
  final String id;
  final String nome;

  GlobalHfEscolasModel({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
    };
  }

  factory GlobalHfEscolasModel.fromMap(Map<String, dynamic> map) {
    return GlobalHfEscolasModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalHfEscolasModel.fromJson(String source) => GlobalHfEscolasModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
