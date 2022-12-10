import 'package:flutter/material.dart';
import 'package:salons_adminka/utils/app_colors.dart';
import 'package:salons_adminka/utils/app_text_style.dart';

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
          width: width,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 44),
          decoration: BoxDecoration(
            color: isEnabled ? (buttonColor ?? AppColors.darkRose) : AppColors.darkBackground,
            borderRadius: BorderRadius.circular(52),
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle ??
                AppTextStyle.buttonText.copyWith(
                  color: isEnabled ? textColor ?? AppColors.lightBackground : AppColors.disabledColor,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    if (width == null) {
      return FittedBox(child: child);
    }
    return child;
  }
}
