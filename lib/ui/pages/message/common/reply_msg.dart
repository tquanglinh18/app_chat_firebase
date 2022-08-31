import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class ReplyMsg extends StatelessWidget {
  String? message;
  bool? isSent = false;
  String? textReply;
  String? timer;

  ReplyMsg({
    Key? key,
    this.message,
    this.isSent = false,
    this.textReply,
    this.timer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
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
            Row(
              children: [
                Container(
                  width: 5,
                  height: 30,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSent == false ? AppColors.btnColor : AppColors.hintTextColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSent == false ? AppColors.greyBG : AppColors.backgroundLight,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Text(
                      message!,
                      style: AppTextStyle.blackS14.copyWith(),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              textReply!,
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
    );
  }
}
