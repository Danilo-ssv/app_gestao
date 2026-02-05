import 'package:flutter/material.dart';

class CustomMenuActionButton extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  final Color? color;
  CustomMenuActionButton({
    super.key,
    required this.onTap,
    required this.label,
    this.color,
  });

  final ValueNotifier<bool> isHover = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isHover,
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Material(
          color: value ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: onTap,
            onHover: (value) => isHover.value = value,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: value ? Colors.white : color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
