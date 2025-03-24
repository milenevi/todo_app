import 'package:flutter/material.dart';

class DividerLine extends StatelessWidget {
  const DividerLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withAlpha(26)
            : Colors.black.withAlpha(26),
      ),
    );
  }
}
