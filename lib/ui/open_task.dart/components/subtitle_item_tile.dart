import 'package:flutter/material.dart';
import 'package:todoapp/ui/open_task.dart/components/small_button.dart';

class SubtaskItemTile extends StatelessWidget {
  const SubtaskItemTile({
    required this.leadingCallback,
    required this.title,
    required this.trailingCallback,
    this.visibleTariling,
    Key? key,
  }) : super(key: key);

  final VoidCallback leadingCallback;
  final Widget title;
  final VoidCallback trailingCallback;
  final bool? visibleTariling;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // leading
        SmallButton(
          onTap: () => leadingCallback(),
          icon: Icons.circle_outlined,
        ),
        // descripcion
        title,
        // trailing
        Visibility(
          visible: visibleTariling ?? true,
          child: SmallButton(
            onTap: () => trailingCallback(),
            icon: Icons.close_rounded,
          ),
        ),
      ],
    );
  }
}
