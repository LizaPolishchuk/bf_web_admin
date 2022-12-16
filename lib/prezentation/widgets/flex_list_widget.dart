import 'package:flutter/cupertino.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FlexListWidget extends StatelessWidget {
  const FlexListWidget({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation size) {
      return Flex(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: size.isDesktop ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceAround,
        direction: size.isDesktop ? Axis.horizontal : Axis.vertical,
        children: size.isDesktop ? children : children.reversed.toList(),
      );
    });
  }
}
