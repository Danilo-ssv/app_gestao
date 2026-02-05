import 'package:app_gestao/src/modules/marcas_produtos/models/insert_marcas_produtos_model.dart';
import 'package:app_gestao/src/modules/marcas_produtos/state/marcas_produtos_state.dart';
import 'package:flutter/material.dart';
import 'package:app_gestao/src/shared/functions/show_error_message.dart';
import 'package:provider/provider.dart';

class InsertMarcasProdutosPage extends StatefulWidget {
  final String id;
  final bool clone;
  final Function onSave;
  const InsertMarcasProdutosPage({super.key, required this.id, required this.clone, required this.onSave});

  @override
  State<InsertMarcasProdutosPage> createState() => _InsertMarcasProdutosPageState();
}

class _InsertMarcasProdutosPageState extends State<InsertMarcasProdutosPage> {
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
    final res = await context.read<MarcasProdutosState>().readById(
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

    final res = await context.read<MarcasProdutosState>().insert(
          context,
          InsertMarcasProdutosModel(
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
        title: const Text('Inserir Marca de Produtos'),
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
