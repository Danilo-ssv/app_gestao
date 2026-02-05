class PermissoesUsuariosModelo {
  final String modulo;
  final List<({String id, String nome})> opcoes;

  PermissoesUsuariosModelo({
    required this.modulo,
    required this.opcoes,
  });
}
