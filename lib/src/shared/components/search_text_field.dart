import 'dart:async';

import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value) onChanged;
  final Function onFinished;
  final double? width;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFinished,
    this.width = 200,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? _checkTypingTimer;

  startTimer() {
    _checkTypingTimer = Timer(const Duration(milliseconds: 700), () => widget.onFinished());
  }

  resetTimer() {
    _checkTypingTimer?.cancel();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onChanged(value);
        resetTimer();
      },
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      // cursorOpacityAnimates: true,
      // cursorColor: Colors.black,
      // cursorHeight: 20,
      // style: const TextStyle(fontSize: 14, height: 1.5),
      // cursorWidth: 1,
      decoration: const InputDecoration(
        // alignLabelWithHint: true,
        // isDense: true,
        // floatingLabelAlignment: FloatingLabelAlignment.center,
        // constraints: BoxConstraints(maxHeight: 35),
        // // contentPadding: EdgeInsets.all(7),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(6)),
        //   borderSide: BorderSide(color: Color(0xffcbd0dd)),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(6)),
        //   borderSide: BorderSide(color: Colors.blue),
        // ),
        // fillColor: Colors.white,
        // filled: true,
        hintText: 'Pesquisar...',
        // hintStyle: TextStyle(color: Color(0xff8a94ad), fontSize: 14),
        // prefixIcon: Icon(Icons.search, color: Color(0xff8a94ad)),
        // prefixIcon: Icon(Icons.search, color: Color(0xffcbd0dd)),
      ),
    );
  }
}
