import 'package:flutter/material.dart';
import 'package:todoapp/ui/shared_components/custom_text_field.dart';

class SubtaskTile extends StatelessWidget {
  const SubtaskTile({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: 20),
          Expanded(child: Text(title)),
          // CustomTextField(
          //   textValue: title,
          //   myFunction: (value) {
          //     // task.value.description = value;
          //     // task.refresh();
          //   },
          // ),
        ],
      ),
    );
  }
}


