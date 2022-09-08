import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/loading_indicator_widget.dart';

import '../../common/app_colors.dart';

enum ButtonType {
  ACTIVE,
  IN_ACTIVE,
}

extension ButtonTypeExtension on ButtonType {
  Color get colorBackgroundStatus {
    switch (this) {
      case ButtonType.ACTIVE:
        return AppColors.btnColor;
      case ButtonType.IN_ACTIVE:
        return AppColors.buttonBGWhite;
    }
  }
}

class AppButtons extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final ButtonType buttonType;
  final bool isLoading;
  final double? width;
  final double heightButton;
  final double circularButton;

  const AppButtons({
    Key? key,
    this.title,
    this.onTap,
    this.buttonType = ButtonType.IN_ACTIVE,
    this.isLoading = false,
    this.width,
    this.heightButton = 52,
    this.circularButton = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonType == ButtonType.ACTIVE ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
        height: heightButton,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circularButton),
          color: buttonType.colorBackgroundStatus,
        ),
        child: Center(
          child: isLoading
              ? const LoadingIndicatorWidget(color: Colors.white)
              : Text(
                  title!,
                  style: AppTextStyle.whiteS16.copyWith(fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
