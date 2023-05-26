import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

class MyChip extends StatelessWidget {
  const MyChip({
    required this.iconData,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData iconData;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: softGrey.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Icon(iconData, size: 16, color: enabledGrey),
            const SizedBox(width: 8),
            Text(label, style: kLabelMedium),
          ],
        ),
      ),
    );
  }
}
