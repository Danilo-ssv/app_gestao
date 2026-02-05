import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<DropdownMenuEntry> dropdownMenuEntries;
  final TextEditingController? controller;
  final double? width;
  final double? maxHeight;
  final String? initialSelection;
  final String? title;
  final String? hintText;
  final Function(dynamic value)? onSelected;

  const CustomDropdownMenu({
    super.key,
    required this.dropdownMenuEntries,
    this.width,
    this.maxHeight,
    this.initialSelection,
    this.controller,
    this.title,
    this.hintText,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ],
          DropdownMenu(
            controller: controller,
            onSelected: (value) =>
                onSelected != null ? onSelected!(value) : null,
            width: width,
            initialSelection: initialSelection,
            menuHeight: 200,
            hintText: hintText,
            dropdownMenuEntries: dropdownMenuEntries,
            enableSearch: false,
            // trailingIcon: Icon(Icons.abc),
            textStyle: TextStyle(
              fontSize: 14
            ),
          //         cursorOpacityAnimates: true,
          // cursorColor: Colors.black,
          // cursorHeight: 20,
          // style: const TextStyle(fontSize: 14, height: 1.5),
          // cursorWidth: 1,
          menuStyle: MenuStyle(
            
          ),
            inputDecorationTheme: InputDecorationTheme(
              suffixStyle: TextStyle(),

              isDense: true,
              contentPadding: const EdgeInsets.all(13),
              constraints: BoxConstraints.tight(
                  Size.fromHeight(maxHeight ?? 35)),
              alignLabelWithHint: true,
              floatingLabelAlignment: FloatingLabelAlignment.center,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 187, 191, 203)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
