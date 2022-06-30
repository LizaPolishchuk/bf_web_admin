import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';

class InfoContainer extends StatelessWidget {
  final Widget child;
  final ValueNotifier<Widget?> showInfoNotifier;

  const InfoContainer({Key? key, required this.child, required this.showInfoNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 42, right: 38),
          child: child,
        ),
        ValueListenableBuilder<Widget?>(
          valueListenable: showInfoNotifier,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: value != null ? child : const SizedBox.shrink(),
            );
          },
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: GestureDetector(
                onTap: (){
                  showInfoNotifier.value = null;
                },
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: ValueListenableBuilder<Widget?>(
            valueListenable: showInfoNotifier,
            builder: (context, value, child) {
              return AnimatedContainer(
                width: value != null ? 360 : 0,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blurColor.withOpacity(0.25),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 200),
                child: value,
              );
            },
          ),
        ),
      ],
    );
  }
}
