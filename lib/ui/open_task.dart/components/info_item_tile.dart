import 'package:flutter/material.dart';

class InfoItemTile extends StatelessWidget {
  const InfoItemTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap != null ? () => onTap!() : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 20),
                  Text(title),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 40,
          width: 60,
          alignment: Alignment.center,
          child: trailing ??
              const SizedBox(
                height: 40,
                width: 40,
              ),
        ),
      ],
    );
  }
}
