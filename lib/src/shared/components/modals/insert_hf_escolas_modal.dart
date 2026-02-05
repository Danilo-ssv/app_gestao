import 'package:flutter/material.dart';
import 'package:app_gestao/src/shared/providers/global_provider.dart';
import 'package:provider/provider.dart';

class InsertHfEscolasModal extends StatefulWidget {
  final Function(String id, String nome) onSave;
  const InsertHfEscolasModal({super.key, required this.onSave});

  @override
  State<InsertHfEscolasModal> createState() => _InsertHfEscolasModalState();
}

class _InsertHfEscolasModalState extends State<InsertHfEscolasModal> {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final _nomeController = TextEditingController();

  void insert() async {
    isLoading.value = true;
    final res = await context.read<GlobalProvider>().insertHfEscolas(context, _nomeController.text);

    if (!mounted) return;

    Navigator.pop(context);

    if (res != null) {
      widget.onSave(res, _nomeController.text);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    isLoading.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removeViewInsets(
      context: context,
      removeBottom: true,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              const Text('Colégios', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 5),
              const Text('Insira algum Colégio!', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 15),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
                onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, value, child) => TextButton(
                      onPressed: value ? null : insert,
                      child: value ? const CircularProgressIndicator() : const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
