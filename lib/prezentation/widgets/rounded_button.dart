import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_theme.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;
  final double? width;
  final Color? buttonColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final double? height;

  const RoundedButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.isEnabled = true,
      this.isLoading = false,
      this.width,
      this.buttonColor,
      this.textStyle,
      this.textColor,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(52),
      enableFeedback: isEnabled,
      onTap: () {
        if (isEnabled) {
          onPressed();
        }
      },
      child: _buildContainer(
        child: Container(
          height: height ?? 50,
          width: width ?? 250,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 44),
          decoration: BoxDecoration(
            color: isEnabled
                ? buttonColor ?? Theme.of(context).colorScheme.primary
                : AppColors.disabledColor,
            borderRadius: BorderRadius.circular(52),
          ),
          child: child ??
              Text(
                text ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle ??
                    Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isEnabled
                              ? (AppTheme.isDark ? Colors.white : textColor) ??
                                  AppColors.lightBackground
                              : Colors.white,
                        ),
              ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    if (width == null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: child,
      );
    }
    return child;
  }
}
