import 'package:flutter/material.dart';

class ExpandibleOptionsItem extends StatelessWidget {
  const ExpandibleOptionsItem({
    required this.leading,
    required this.title,
    this.onTap,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final IconData leading;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [        

        Expanded(
          child: InkWell(
            onTap: onTap != null ? () => onTap!() : null,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              child: Wrap(
                children: [
                  Icon(leading, size: 20),
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
