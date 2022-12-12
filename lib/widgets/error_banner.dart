import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String? text;

  const ErrorBanner(this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).errorColor;
    final backgroundColor =
        HSLColor.fromColor(errorColor).withLightness(0.9).toColor();
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      padding: const EdgeInsets.all(12),
      child: Text(
        text != null ? text! : '',
        style: TextStyle(color: errorColor),
      ),
    );
  }
}