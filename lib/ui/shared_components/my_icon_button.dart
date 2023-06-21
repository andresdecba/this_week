import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    this.iconData,
    required this.label,
    required this.onTap,
    required this.isEnabled,
    this.color,
    super.key,
  });

  final IconData? iconData;
  final String label;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var iconColor = isEnabled ? myChipText : disabledGrey;

    return InkWell(
      splashColor: splashColorButtons,
      customBorder: const CircleBorder(),
      onTap: isEnabled ? () => onTap() : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color ?? softGrey.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Row(
          children: [
            Icon(iconData, size: 24, color: iconColor),
          ],
        ),
      ),
    );
  }
}
