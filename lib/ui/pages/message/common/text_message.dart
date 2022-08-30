import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class TextMessage extends StatelessWidget {
  String? message;
  bool? isSent = false;
  bool? isSeen = false;
  String? timer;
  Function()? onLongPress;

  TextMessage({
    Key? key,
    this.message,
    this.isSent = false,
    this.isSeen = false,
    this.timer,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isSent != false ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: isSent != false ? const EdgeInsets.fromLTRB(93, 6, 6, 6) : const EdgeInsets.fromLTRB(6, 6, 93, 6),
          decoration: BoxDecoration(
            color: (isSent != true) ? AppColors.backgroundLight : AppColors.btnColor,
            borderRadius: (isSent != true)
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
          ),
          child: Column(
            crossAxisAlignment: (isSent != true) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message!,
                style: (isSent != true)
                    ? AppTextStyle.blackS14.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      )
                    : AppTextStyle.whiteS14.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                timer!,
                style: (isSent != true)
                    ? AppTextStyle.blackS14.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      )
                    : AppTextStyle.whiteS14.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
