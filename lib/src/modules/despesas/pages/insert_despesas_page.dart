import 'package:flutter/material.dart';
import 'package:app_gestao/src/modules/despesas/models/insert_despesas_model.dart';
import 'package:app_gestao/src/modules/despesas/state/despesas_state.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:provider/provider.dart';

class InsertDespesasPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertDespesasPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertDespesasPage> createState() => _InsertDespesasPageState();
}

class _InsertDespesasPageState extends State<InsertDespesasPage> {
  String _id = '';
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.id.isNotEmpty) {
      readById();
    }
  }

  void readById() async {
    final res = await context.read<DespesasState>().readById(
          context,
          widget.id,
        );

    setState(() {
      _id = widget.clone ? '' : (res?.id ?? '');
      _nomeController.text = res?.nome ?? '';
    });
  }

  void insert() async {
    if (_nomeController.text.isEmpty) {
      showErrorMessage(context, message: 'Nome é Obrigatório!', success: false);
      return;
    }

    final res = await context.read<DespesasState>().insert(
          context,
          InsertDespesasModel(
            id: _id,
            nome: _nomeController.text,
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
        title: const Text('Inserir Despesa'),
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
                    maxLength: 100,
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      label: Text('Nome'),
                      counterText: '',
                    ),
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
