import 'package:flutter/material.dart';

class BorrarDos extends StatelessWidget {
  const BorrarDos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        TextFormField(),
        TextFormField(),
      ],
    ));
  }
}
