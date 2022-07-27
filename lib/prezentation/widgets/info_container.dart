import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';

enum InfoAction { view, edit, add, delete }

class InfoContainer extends StatelessWidget {
  final Widget child;
  final ValueNotifier<Widget?> showInfoNotifier;
  final VoidCallback onPressedAddButton;
  final bool hideAddButton;

  const InfoContainer(
      {Key? key,
      required this.child,
      required this.showInfoNotifier,
      required this.onPressedAddButton,
      this.hideAddButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: hideAddButton
          ? null
          : ValueListenableBuilder<Widget?>(
              valueListenable: showInfoNotifier,
              builder: (context, value, child) {
                return FloatingActionButton(
                  backgroundColor: value == null ? AppColors.darkRose : AppColors.darkTurquoise,
                  child: Icon(value == null ? Icons.add : Icons.close, color: Colors.white),
                  onPressed: () {
                    if (value == null) {
                      onPressedAddButton();
                    } else {
                      showInfoNotifier.value = null;
                    }
                  },
                );
              },
            ),
      body: Stack(
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
                  onTap: () {
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
                return AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
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
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: value),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
