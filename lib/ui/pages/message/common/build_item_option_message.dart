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

class ItemOptioneMsg extends StatefulWidget {
  final IconData? iconItem;
  final String? title;
  final ButtonType? buttonType;
  final VoidCallback? onTap;

  const ItemOptioneMsg({
    Key? key,
    this.iconItem,
    this.title,
    this.buttonType,
    this.onTap,
  }) : super(key: key);

  @override
  State<ItemOptioneMsg> createState() => _ItemOptioneMsgState();
}

class _ItemOptioneMsgState extends State<ItemOptioneMsg> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.buttonType == ButtonType.ACTIVE ? widget.onTap : null,
      child: Column(
        children: [
          _iconOption,
          _titleOption,
        ],
      ),
    );
  }

  Widget get _titleOption {
    return Text(
      widget.title!,
      style: AppTextStyle.blackS14.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 2,
          color: widget.buttonType == ButtonType.IN_ACTIVE
              ? Theme.of(context).indicatorColor
              : Theme.of(context).iconTheme.color!),
    );
  }

  Widget get _iconOption {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.hintTextColor,
      ),
      child: Icon(
        widget.iconItem,
        size: 20,
        color: widget.buttonType == ButtonType.ACTIVE ? AppColors.btnColor : AppColors.bgrColorsChatPage,
      ),
    );
  }
}
