import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

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

class ItemOptioneMsg extends StatelessWidget {
  final IconData? iconItem;
  final String? title;
  final ButtonType? buttonType;
  final VoidCallback? onTap;

  const ItemOptioneMsg({Key? key, this.iconItem, this.title, this.buttonType, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonType == ButtonType.ACTIVE ? onTap : null,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.hintTextColor,
            ),
            child: Icon(
              iconItem,
              size: 20,
              color: buttonType == ButtonType.ACTIVE ? AppColors.btnColor : AppColors.bgrColorsChatPage,
            ),
          ),
          Text(
            title!,
            style: AppTextStyle.blackS14.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
