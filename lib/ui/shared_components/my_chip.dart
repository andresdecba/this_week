import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

class MyChip extends StatelessWidget {
  const MyChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color ?? softGrey.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Icon(iconData, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(label, style: kLabelMedium.copyWith(color: iconColor)),
          ],
        ),
      ),
    );
  }
}
