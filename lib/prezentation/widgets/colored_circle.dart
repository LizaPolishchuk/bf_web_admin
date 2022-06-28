import 'package:flutter/material.dart';

class ColoredCircle extends StatelessWidget {
  final Color color;
  final int? height;
  final int? width;

  const ColoredCircle({Key? key, required this.color, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
