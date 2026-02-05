import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final Function onTap;
  final String label;
  final IconData icon;
  final double height;
  final double width;
  final double maxWidth;

  const CustomListtile({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.height,
    required this.width,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width,
                child: Center(
                  child: Icon(icon, size: 20),
                ),
              ),
              SizedBox(
                width: maxWidth,
                child: Text(label, overflow: TextOverflow.clip, maxLines: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
