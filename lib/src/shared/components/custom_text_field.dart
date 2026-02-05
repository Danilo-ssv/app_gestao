import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChange;
  final String? title;
  final Widget? suffixTitle;
  final String? hintText;
  final String? prefixText;
  final int? maxLength;
  final int? maxLines;
  final double? maxHeight;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  final TextAlign? textAlign;
  final Function()? onTap;

  const CustomTextfield({
    super.key,
    required this.controller,
    this.onChange,
    this.title,
    this.suffixTitle,
    this.hintText,
    this.prefixText,
    this.maxLength,
    this.maxLines = 1,
    this.maxHeight,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
            suffixTitle ?? const SizedBox(),
          ],
        ),
        TextField(
          readOnly: readOnly!,
          onTap: onTap,
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) => onChange != null ? onChange!(value) : null,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          maxLines: maxLines,
          cursorOpacityAnimates: true,
          cursorColor: Colors.black,
          cursorHeight: 20,
          style: const TextStyle(fontSize: 14, height: 1.5),
          cursorWidth: 1,
          textAlign: textAlign!,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            isDense: true,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            constraints: BoxConstraints(
              maxHeight: maxHeight ?? double.infinity,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Color.fromARGB(255, 187, 191, 203)),
              // borderSide: BorderSide(color: Color(0xffcbd0dd)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.white,
            filled: true,
            hintStyle: const TextStyle(
              color: Color(0xff8a94ad),
              fontSize: 14,
            ),
            // prefixIcon: const Icon(Icons.search, color: Color(0xff8a94ad)),
            hintText: hintText ?? '',
            prefixText: prefixText,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
