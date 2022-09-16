import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:open_file/open_file.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class ReplyMsg extends StatelessWidget {
  final String? message;
  final bool isSent;

  final String? textReply;
  final String? timer;
  final String nameSend;
  final String nameReply;
  final List<DocumentEntity> listDocument;

  const ReplyMsg({
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
    final theme = Theme.of(context);
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
              color: (isSent != true) ? theme.hoverColor : AppColors.btnColor,
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
                _msgReply(
                  theme.focusColor,
                  theme.iconTheme.color!,
                ),
                _replyText(theme.iconTheme.color!),
                const SizedBox(height: 4),
                _msgTimer(theme.iconTheme.color!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _replyText(
    Color darkModeTextColor,
  ) {
    return Text(
      textReply!,
      style: (isSent != true)
          ? AppTextStyle.blackS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: darkModeTextColor,
            )
          : AppTextStyle.whiteS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
    );
  }

  Widget _msgTimer(
    Color darkModeTimerColor,
  ) {
    return Text(
      timer!,
      style: (isSent != true)
          ? AppTextStyle.blackS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: darkModeTimerColor,
            )
          : AppTextStyle.whiteS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
    );
  }

  Widget _msgReply(Color darkModeColorReply, Color darkModeMsgIsReply) {
    return Row(
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
              color: isSent == false ? darkModeColorReply : AppColors.backgroundLight,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameSend,
                listDocument.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          OpenFile.open(listDocument.first.path!);
                        },
                        child: SizedBox(
                          height: 200,
                          child: ImgFile(
                            urlFile: listDocument.first.type == TypeDocument.VIDEO.toTypeDocument
                                ? listDocument.first.pathThumbnail!
                                : listDocument.first.path!,
                            isSent: isSent,
                            textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
                            isReplyColor: AppColors.textBlack,
                            darkModeIconColor: darkModeMsgIsReply,
                          ),
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: _msgIsReply(isSent ? AppColors.textBlack : darkModeMsgIsReply),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _nameSend {
    return Text(
      nameSend,
      style: AppTextStyle.greyS12.copyWith(fontSize: 10),
    );
  }

  Widget _msgIsReply(Color darkModeMsgIsReply) {
    return Text(
      message!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.blackS14.copyWith(color: darkModeMsgIsReply),
    );
  }
}
