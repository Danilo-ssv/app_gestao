import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/usuarios/models/insert_usuarios_model.dart';
import 'package:app_gestao/src/modules/usuarios/models/permissoes_usuarios_modelo.dart';
import 'package:app_gestao/src/modules/usuarios/pages/widgets/opcao_permissao_widget.dart';
import 'package:app_gestao/src/modules/usuarios/state/usuarios_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:provider/provider.dart';

class InsertUsuariosPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertUsuariosPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertUsuariosPage> createState() => _InsertUsuariosPageState();
}

class _InsertUsuariosPageState extends State<InsertUsuariosPage> {
  String _id = '';
  // String _id = '6';
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  List<({String id, String permissao, bool delete})> listaPermissoes = [];
  // List<({String id, String permissao, bool delete})> listaPermissoes = [
  //   (delete: false, id: '5', permissao: '2'),
  //   (delete: false, id: '6', permissao: '4'),
  //   (delete: false, id: '7', permissao: '5'),
  // ];

  @override
  void initState() {
    super.initState();

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<UsuariosState>().readById(
          context,
          widget.id,
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _emailController.text = res?.email ?? '';
      _senhaController.text = res?.senha ?? '';
    });
  }

  void insert() async {
    if (_emailController.text.isEmpty) {
      showErrorMessage(context, message: 'E-mail é Obrigatório!', success: false);
      return;
    }

    if (_senhaController.text.isEmpty) {
      showErrorMessage(context, message: 'Senha é Obrigatório!', success: false);
      return;
    }

    final res = await context.read<UsuariosState>().insert(
          context,
          InsertUsuariosModel(
            id: _id,
            email: _emailController.text,
            senha: _senhaController.text,
            listaPermissoes: listaPermissoes,
          ),
        );

    if (res) {
      widget.onSave();
    }
  }

  final permissoesUsuarios = [
    PermissoesUsuariosModelo(
      modulo: 'Clientes',
      opcoes: [
        (id: '1', nome: 'Somente Leitura'),
        (id: '2', nome: 'Leitura e Edição'),
      ],
    ),
    PermissoesUsuariosModelo(
      modulo: 'Agenda',
      opcoes: [
        (id: '3', nome: 'Somente Leitura'),
        (id: '4', nome: 'Leitura e Edição'),
      ],
    ),
    PermissoesUsuariosModelo(
      modulo: 'Produtos',
      opcoes: [
        (id: '5', nome: 'Somente Leitura'),
        (id: '6', nome: 'Leitura e Edição'),
      ],
    ),
    PermissoesUsuariosModelo(
      modulo: 'Usuários',
      opcoes: [
        (id: '7', nome: 'Somente Leitura'),
        (id: '8', nome: 'Leitura e Edição'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir Usuário'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => insert(),
        label: Row(
          children: [
            Text('Salvar'),
            SizedBox(width: 10),
            Icon(Icons.check),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text('E-mail'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      label: Text('Senha'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...permissoesUsuarios.map(
              (permissao) => OpcaoPermissaoWidget(
                listaPermissoes: listaPermissoes,
                permissao: permissao,
                onChanged: (oldValue, newValue) {
                  for (int index = 0; index < listaPermissoes.length; index++) {
                    final deleteItem = listaPermissoes[index];

                    if (deleteItem.permissao == oldValue) {
                      if (deleteItem.id.isEmpty) {
                        listaPermissoes.removeAt(index);
                      } else {
                        listaPermissoes[index] = (id: deleteItem.id, permissao: deleteItem.permissao, delete: true);
                      }
                      break;
                    }
                  }

                  bool addNewValue = true;

                  for (int index = 0; index < listaPermissoes.length; index++) {
                    final addItem = listaPermissoes[index];

                    if (addItem.permissao == newValue) {
                      addNewValue = false;
                      listaPermissoes[index] = (id: addItem.id, permissao: addItem.permissao, delete: false);
                      break;
                    }
                  }

                  if (addNewValue) {
                    listaPermissoes.add((id: '', permissao: newValue, delete: false));
                  }

                  print(listaPermissoes);
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
