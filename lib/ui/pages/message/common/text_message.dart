import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:open_file/open_file.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class TextMessage extends StatefulWidget {
  final String? message;
  final bool isSent;
  final String? timer;
  final Function()? onLongPress;
  final List<DocumentEntity> listDocumnet;
  final String nameSend;
  final String nameConversion;
  final Color isDarkModeMsg;

  const TextMessage({
    Key? key,
    this.message,
    this.isSent = false,
    this.timer,
    this.onLongPress,
    this.listDocumnet = const [],
    this.nameSend = '',
    this.nameConversion = '',
    this.isDarkModeMsg = AppColors.backgroundLight,
  }) : super(key: key);

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Align(
        alignment: widget.isSent != false ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: widget.isSent != true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            _nameSentMsg,
            Container(
              padding: const EdgeInsets.all(10),
              margin: widget.isSent != false
                  ? const EdgeInsets.fromLTRB(93, 2, 6, 6)
                  : const EdgeInsets.fromLTRB(6, 2, 93, 6),
              decoration: BoxDecoration(
                color: (widget.isSent != true) ? widget.isDarkModeMsg : AppColors.btnColor,
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
                  widget.listDocumnet.isNotEmpty
                      ? (widget.listDocumnet.first.type == TypeDocument.IMAGE.toTypeDocument)
                          ? _typeImageMsg(() {
                              OpenFile.open(widget.listDocumnet.first.path!);
                            })
                          : (widget.listDocumnet.first.type == TypeDocument.VIDEO.toTypeDocument)
                              ? _typeVideoMsg(() {
                                  OpenFile.open(widget.listDocumnet.first.path!);
                                })
                              : widget.listDocumnet.first.type == TypeDocument.FILE.toTypeDocument
                                  ? _typeFileMsg
                                  : const SizedBox()
                      : const SizedBox(),
                  const SizedBox(height: 4),
                  _msgText,
                  const SizedBox(height: 4),
                  _msgTimer,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _msgText {
    return Text(
      widget.message!,
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

  Widget get _nameSentMsg {
    return Text(
      widget.nameSend,
      style: AppTextStyle.greyS12.copyWith(fontSize: 10),
    );
  }

  Widget get _typeFileMsg {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: InkWell(
        onTap: () {
          OpenFile.open(widget.listDocumnet.first.path);
        },
        child: Image.asset(
          AppImages.icFileDefault,
          color: widget.isSent ? AppColors.backgroundLight : Theme.of(context).iconTheme.color!,
          height: 100,
          width: 100,
        ),
      ),
    );
  }

  Widget _typeVideoMsg(
    Function() onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImgFile(
              urlFile: widget.listDocumnet.first.pathThumbnail ?? "",
              isSent: widget.isSent,
              textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
              documentIsVideo: true,
              isBorderSide: true,
              darkModeIconColor: Theme.of(context).iconTheme.color!,
              isReplyColor: AppColors.backgroundLight,
            ),
            Icon(
              Icons.play_circle_fill_outlined,
              size: 50,
              color: widget.isSent ? AppColors.backgroundLight : Theme.of(context).iconTheme.color!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeImageMsg(Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: ImgFile(
        urlFile: widget.listDocumnet.first.path!,
        textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
        isSent: widget.isSent,
        isBorderSide: true,
        darkModeIconColor: Theme.of(context).iconTheme.color!,
      ),
    );
  }
}
