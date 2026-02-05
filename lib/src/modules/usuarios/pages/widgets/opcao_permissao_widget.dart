import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/usuarios/models/permissoes_usuarios_modelo.dart';

class OpcaoPermissaoWidget extends StatefulWidget {
  final List<({String id, String permissao, bool delete})> listaPermissoes;
  final PermissoesUsuariosModelo permissao;
  final Function(String oldValue, String newValue) onChanged;
  const OpcaoPermissaoWidget({super.key, required this.listaPermissoes, required this.permissao, required this.onChanged});

  @override
  State<OpcaoPermissaoWidget> createState() => _OpcaoPermissaoWidgetState();
}

class _OpcaoPermissaoWidgetState extends State<OpcaoPermissaoWidget> {
  String selectOpcao = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.permissao.modulo),
        ...widget.permissao.opcoes.map((opcao) {
          widget.listaPermissoes.map((e) => e.permissao == opcao.id && !e.delete ? selectOpcao = opcao.id : null).toList();

          return Row(
            children: [
              Radio(
                value: opcao.id,
                groupValue: selectOpcao,
                onChanged: (value) {
                  if (value == null) return;
                  widget.onChanged(selectOpcao, value);
                  setState(() => selectOpcao = value);
                  // if (listaPermissoes.contains(opcao.id)) {
                  //   print('removeu');
                  //   setState(() => listaPermissoes.remove(opcao.id));
                  //   return;
                  // }
                  // print('adicionou');
                  // setState(() => listaPermissoes.add(opcao.id));
                },
              ),
              Text(opcao.nome),
            ],
          );
        }),
      ],
    );
  }
}
