import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    required this.onTap,
    required this.icon,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
