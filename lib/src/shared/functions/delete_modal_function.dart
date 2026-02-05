import 'package:flutter/material.dart';

void deleteModalFunction(BuildContext context, {required int length, required Future Function() function}) {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Exclusão'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              length == 1 ? Text('Deseja realmente excluir $length Item?') : Text('Deseja realmente excluir $length Itens?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, value, child) => TextButton(
              onPressed: value
                  ? null
                  : () {
                      isLoading.value = true;
                      function().then((_) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    },
              child: value ? const CircularProgressIndicator() : const Text('Excluir'),
            ),
          ),
        ],
      );
    },
  );
}
