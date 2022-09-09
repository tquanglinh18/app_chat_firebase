import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/message/pages/play_video.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:open_file/open_file.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class TextMessage extends StatelessWidget {
  String? message;
  bool isSent;
  String? timer;
  Function()? onLongPress;
  List<Document> listDocumnet;
  String nameSend;
  String nameConversion;

  TextMessage({
    Key? key,
    this.message,
    this.isSent = false,
    this.timer,
    this.onLongPress,
    this.listDocumnet = const [],
    this.nameSend = '',
    this.nameConversion = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isSent != false ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSent != true ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            _nameSentMsg,
            Container(
              padding: const EdgeInsets.all(10),
              margin: isSent != false ? const EdgeInsets.fromLTRB(93, 2, 6, 6) : const EdgeInsets.fromLTRB(6, 2, 93, 6),
              decoration: BoxDecoration(
                color: (isSent != true) ? AppColors.backgroundLight : AppColors.btnColor,
                borderRadius: (isSent != true)
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        // topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
              ),
              child: Column(
                crossAxisAlignment: (isSent != true) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  listDocumnet.isNotEmpty
                      ? (listDocumnet.first.type == TypeDocument.IMAGE.toTypeDocument)
                          ? _typeImageMsg
                          : (listDocumnet.first.type == TypeDocument.VIDEO.toTypeDocument)
                              ? _typeVideoMsg(
                                  () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PlayVideo(
                                          nameConversion: nameConversion,
                                          path: listDocumnet.first.path!,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : listDocumnet.first.type == TypeDocument.FILE.toTypeDocument
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
    );
  }

  Widget get _msgTimer {
    return Text(
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
    );
  }

  Widget get _nameSentMsg {
    return Text(
      nameSend,
      style: AppTextStyle.greyS12.copyWith(fontSize: 10),
    );
  }

  Widget get _typeFileMsg {
    return InkWell(
      onTap: () {
        OpenFile.open(listDocumnet.first.path);
      },
      child: const Icon(
        Icons.file_present_outlined,
        size: 100,
      ),
    );
  }

  Widget _typeVideoMsg(Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ImgFile(
              urlFile: listDocumnet.first.pathThumbnail ?? "",
              isSent: isSent,
              textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
              documentIsVideo: true,
            ),
          ),
          const Icon(
            Icons.play_circle_fill_outlined,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget get _typeImageMsg {
    return ImgFile(
      urlFile: listDocumnet.first.path!,
      textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
      isSent: isSent,
    );
  }
}
