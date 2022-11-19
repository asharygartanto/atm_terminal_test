import 'package:flutter/material.dart';

class ToolbarButton extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;

  const ToolbarButton({Key? key, required this.gradient, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 15,
        height: 15,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradient),
        child: child);
  }
}
