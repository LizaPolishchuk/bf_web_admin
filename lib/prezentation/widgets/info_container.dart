import 'dart:ui';

import 'package:bf_web_admin/utils/app_colors.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:bf_web_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

enum InfoAction { view, edit, add, delete }

class InfoContainer extends StatelessWidget {
  final Widget child;
  final ValueNotifier<Widget?> showInfoNotifier;
  final VoidCallback onPressedAddButton;
  final bool hideAddButton;
  final EdgeInsets? padding;

  const InfoContainer(
      {Key? key,
      required this.child,
      required this.showInfoNotifier,
      required this.onPressedAddButton,
      this.padding,
      this.hideAddButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation size) {
      return Scaffold(
          floatingActionButton: hideAddButton
              ? null
              : ValueListenableBuilder<Widget?>(
                  valueListenable: showInfoNotifier,
                  builder: (context, value, child) {
                    return FloatingActionButton(
                      backgroundColor: AppTheme.isDark || value == null
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.darkTurquoise,
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
                padding: padding ?? EdgeInsets.only(left: size.isMobile ? 10 : 42, right: size.isMobile ? 10 : 38),
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
                        width: value != null
                            ? size.isMobile
                                ? MediaQuery.of(context).size.width - Constants.drawerSmallWidth
                                : 360
                            : 0,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: AppTheme.isDark ? AppColors.darkBlue : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blurColor.withOpacity(0.25),
                              blurRadius: 5,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomScrollView(slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: value),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ));
    });
  }
}
