import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class ReplyMsg extends StatelessWidget {
  String? message;
  bool isSent;

  String? textReply;
  String? timer;
  String nameSend;
  String nameReply;
  List<Document> listDocument;

  ReplyMsg({
    Key? key,
    this.message,
    this.isSent = false,
    this.textReply,
    this.timer,
    this.nameSend = '',
    this.nameReply = '',
    this.listDocument = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent != false ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSent != true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            nameReply,
            style: AppTextStyle.greyS12.copyWith(fontSize: 10),
          ),
          Container(
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
                      height: listDocument.isNotEmpty ? 240 : 40,
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
                        height: listDocument.isNotEmpty ? 240 : 40,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSent == false ? AppColors.greyBG : AppColors.backgroundLight,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameSend,
                              style: AppTextStyle.greyS12.copyWith(fontSize: 10),
                            ),
                            listDocument.isNotEmpty
                                ? SizedBox(
                                    height: 200,
                                    child: Image.file(
                                      File(listDocument.first.path!),
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,

                                            children: [

                                              Icon(Icons.info_outline),
                                              Text(
                                                'Đã xảy ra lỗi \nVui lòng thử lại',
                                                textAlign: TextAlign.center,
                                                style: isSent ? AppTextStyle.whiteS14 : AppTextStyle.blackS14,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            Text(
                              message!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.blackS14.copyWith(),
                            ),
                          ],
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
        ],
      ),
    );
  }
}
