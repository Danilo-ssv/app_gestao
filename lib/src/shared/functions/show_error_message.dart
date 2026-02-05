import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String message, required bool success}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        Container(
          width: 5,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            color: success ? Colors.green : Colors.red,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
              color: Color.fromRGBO(73, 72, 72, 1),
            ),
            child: Align(
              widthFactor: double.minPositive,
              alignment: Alignment.centerLeft,
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
        ),
      ],
    ),
    // behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ));
}
