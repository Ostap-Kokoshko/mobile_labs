import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/lab2/elements/photo/Bg2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
