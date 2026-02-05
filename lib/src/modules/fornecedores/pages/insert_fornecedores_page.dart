import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_gestao/src/modules/fornecedores/models/insert_fornecedores_model.dart';
import 'package:app_gestao/src/modules/fornecedores/state/fornecedores_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:provider/provider.dart';

class InsertFornecedoresPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertFornecedoresPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertFornecedoresPage> createState() => _InsertFornecedoresPageState();
}

class _InsertFornecedoresPageState extends State<InsertFornecedoresPage> {
  String _id = '';
  final _nomeController = TextEditingController();
  final _entidadeController = TextEditingController(text: FornecedoresEntidade.$1.formatToString());
  final _docController = TextEditingController();
  final _celularController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<FornecedoresState>().readById(
          context,
          widget.id,
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _nomeController.text = res?.nome ?? '';
      _entidadeController.text = (res?.entidade ?? FornecedoresEntidade.$1).formatToString();
      _docController.text = res?.doc ?? '';
      _celularController.text = res?.celular ?? '';
      _emailController.text = res?.email ?? '';
    });
  }

  void insert() async {
    if (_nomeController.text.isEmpty) {
      showErrorMessage(context, message: 'Nome do Fornecedor é Obrigatório!', success: false);
      return;
    }

    final res = await context.read<FornecedoresState>().insert(
          context,
          InsertFornecedoresModel(
            id: _id,
            nome: _nomeController.text,
            entidade: FornecedoresEntidade.$1.formatToEnum(_entidadeController.text),
            doc: _docController.text,
            celular: _celularController.text,
            email: _emailController.text,
          ),
        );

    if (res) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Fornecedor'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => insert(),
        label: const Row(
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
                    maxLength: 150,
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      label: Text('Nome do Fornecedor'),
                      counterText: '',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownMenu(
                  width: MediaQuery.of(context).size.width / 2 - 15,
                  label: const Text('Tipo de Pessoa'),
                  initialSelection: _entidadeController.text,
                  onSelected: (value) => _entidadeController.text = value ?? FornecedoresEntidade.$1.formatToString(),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: FornecedoresEntidade.$1.formatToString(), label: 'Pessoa Física'),
                    DropdownMenuEntry(value: FornecedoresEntidade.$2.formatToString(), label: 'Pessoa Jurídica'),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    maxLength: 150,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _docController,
                    decoration: const InputDecoration(
                      label: Text('CPF/CNPJ'),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfOuCnpjFormatter(),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _celularController,
                    decoration: const InputDecoration(
                      label: Text('Celular'),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
