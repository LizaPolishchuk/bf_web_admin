import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final Widget? child;
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
      this.text,
      required this.onPressed,
      this.isEnabled = true,
      this.isLoading = false,
      this.width,
      this.buttonColor,
      this.textStyle,
      this.textColor,
      this.height,
      this.child})
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
          width: width ?? 300,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 44),
          decoration: BoxDecoration(
            color: isEnabled
                ? buttonColor ?? (Theme.of(context).brightness == Brightness.dark ? AppColors.blue : AppColors.darkRose)
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
                              ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : textColor) ??
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
