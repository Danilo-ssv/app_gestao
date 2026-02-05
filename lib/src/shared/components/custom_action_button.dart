import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final void Function()? function;
  final IconData icon;
  final Color mainColor;
  final Color bgColor;
  final String? tooptip;
  final EdgeInsets? padding;

  const CustomActionButton({
    super.key,
    required this.function,
    required this.icon,
    required this.mainColor,
    required this.bgColor,
    this.tooptip = '',
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooptip,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: mainColor,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: function,
            child: Padding(
              padding: padding ?? const EdgeInsets.all(2),
              child: Icon(
                icon,
                color: mainColor,
                size: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
