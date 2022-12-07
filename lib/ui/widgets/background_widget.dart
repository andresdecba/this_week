import 'package:flutter/material.dart';
import 'package:todoapp/ui/commons/styles.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    required this.child,
    this.alignment,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: backgroundWidgetBoxDecoration,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      //height: 50,
      child: child,
    );
  }
}
