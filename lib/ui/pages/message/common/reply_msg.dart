import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/commons/img_network.dart';
import 'package:flutter_base/ui/pages/message/pages/view_video_archvies.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:open_file/open_file.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/flus_bar.dart';

class ReplyMsg extends StatefulWidget {
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
  State<ReplyMsg> createState() => _ReplyMsgState();
}

class _ReplyMsgState extends State<ReplyMsg> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSent != false ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: widget.isSent != true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            widget.nameReply,
            style: AppTextStyle.greyS12.copyWith(fontSize: 10),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: widget.isSent != false
                ? const EdgeInsets.fromLTRB(93, 6, 6, 6)
                : const EdgeInsets.fromLTRB(6, 6, 93, 6),
            decoration: BoxDecoration(
              color: (widget.isSent != true) ? Theme.of(context).hoverColor : AppColors.btnColor,
              borderRadius: (widget.isSent != true)
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
              crossAxisAlignment: (widget.isSent != true) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _msgReply,
                _replyText,
                const SizedBox(height: 4),
                _msgTimer,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _replyText {
    return Text(
      widget.textReply!,
      style: (widget.isSent != true)
          ? AppTextStyle.blackS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Theme.of(context).iconTheme.color!,
            )
          : AppTextStyle.whiteS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
    );
  }

  Widget get _msgTimer {
    return Text(
      widget.timer!,
      style: (widget.isSent != true)
          ? AppTextStyle.blackS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: Theme.of(context).iconTheme.color!,
            )
          : AppTextStyle.whiteS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
    );
  }

  Widget get _msgReply {
    return Row(
      children: [
        Container(
          width: 5,
          height: widget.listDocument.isNotEmpty ? 210 : 50,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSent == false ? AppColors.btnColor : AppColors.hintTextColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: widget.listDocument.isNotEmpty ? 210 : 50,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isSent == false ? Theme.of(context).focusColor : AppColors.backgroundLight,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameSend,
                const SizedBox(height: 5),
                widget.listDocument.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          if (widget.listDocument.first.type == TypeDocument.VIDEO.toTypeDocument) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlayVideo(
                                    nameConversion: widget.nameSend, path: widget.listDocument.first.path ?? ''),
                              ),
                            );
                          }
                        },
                        child: widget.listDocument.first.type == TypeDocument.FILE.toTypeDocument
                            ? Center(
                                child: Image.asset(
                                  AppImages.icFileDefault,
                                  height: 150,
                                  color: widget.isSent ? AppColors.backgroundDark : Theme.of(context).iconTheme.color,
                                ),
                              )
                            : SizedBox(
                                height: 150,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ImgNetwork(
                                      urlFile: widget.listDocument.first.type == TypeDocument.VIDEO.toTypeDocument
                                          ? widget.listDocument.first.pathThumbnail!
                                          : widget.listDocument.first.path!,
                                      isSent: widget.isSent,
                                      textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
                                      isReplyColor: AppColors.textBlack,
                                      darkModeIconColor: Theme.of(context).iconTheme.color!,
                                      isReplyMsg: true,
                                      documentIsVideo:
                                          widget.listDocument.first.type == TypeDocument.VIDEO.toTypeDocument
                                              ? true
                                              : false,
                                    ),
                                    widget.listDocument.first.type == TypeDocument.VIDEO.toTypeDocument
                                        ? Icon(
                                            Icons.play_circle_fill_outlined,
                                            size: 50,
                                            color: widget.isSent
                                                ? AppColors.backgroundDark
                                                : Theme.of(context).iconTheme.color!,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 5),
                Expanded(
                  child: _msgIsReply(
                    widget.isSent ? AppColors.textBlack : Theme.of(context).iconTheme.color!,
                  ),
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
      widget.nameSend,
      style: AppTextStyle.greyS12.copyWith(fontSize: 10),
    );
  }

  Widget _msgIsReply(Color darkModeMsgIsReply) {
    return Text(
      widget.message!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.blackS14.copyWith(color: darkModeMsgIsReply),
    );
  }
}
