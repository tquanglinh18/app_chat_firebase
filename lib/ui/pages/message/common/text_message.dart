import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:open_file/open_file.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class TextMessage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                color: (isSent != true) ? isDarkModeMsg : AppColors.btnColor,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1,
                        color: AppColors.greyBG,
                      ),
                    ),
                    child: listDocumnet.isNotEmpty
                        ? (listDocumnet.first.type == TypeDocument.IMAGE.toTypeDocument)
                            ? _typeImageMsg(() {
                                OpenFile.open(listDocumnet.first.path!);
                              }, theme.iconTheme.color!)
                            : (listDocumnet.first.type == TypeDocument.VIDEO.toTypeDocument)
                                ? _typeVideoMsg(
                                    () {
                                      OpenFile.open(listDocumnet.first.path!);
                                    },
                                    theme.iconTheme.color!,
                                  )
                                : listDocumnet.first.type == TypeDocument.FILE.toTypeDocument
                                    ? _typeFileMsg(theme.iconTheme.color!)
                                    : const SizedBox()
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 4),
                  _msgText(theme.iconTheme.color!),
                  const SizedBox(height: 4),
                  _msgTimer(theme.iconTheme.color!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _msgText(Color colorMsgText) {
    return Text(
      message!,
      style: (isSent != true)
          ? AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: colorMsgText)
          : AppTextStyle.whiteS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
    );
  }

  Widget _msgTimer(Color colorMsgTimer) {
    return Text(
      timer!,
      style: (isSent != true)
          ? AppTextStyle.blackS14.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: colorMsgTimer,
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

  Widget _typeFileMsg(Color darkModeIconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: InkWell(
        onTap: () {
          OpenFile.open(listDocumnet.first.path);
        },
        child: Image.asset(
          AppImages.icFileDefault,
          color: isSent ? AppColors.backgroundLight : darkModeIconColor,
          height: 100,
          width: 100,
        ),
      ),
    );
  }

  Widget _typeVideoMsg(
    Function() onTap,
    Color darkModeIconColor,
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
              urlFile: listDocumnet.first.pathThumbnail ?? "",
              isSent: isSent,
              textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
              documentIsVideo: true,
              isBorderSide: true,
              darkModeIconColor: darkModeIconColor,
              isReplyColor: AppColors.backgroundLight,
            ),
            Icon(
              Icons.play_circle_fill_outlined,
              size: 50,
              color: darkModeIconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeImageMsg(Function() onTap, Color darkModeIconColor) {
    return InkWell(
      onTap: onTap,
      child: ImgFile(
        urlFile: listDocumnet.first.path!,
        textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
        isSent: isSent,
        isBorderSide: true,
        darkModeIconColor: darkModeIconColor,
      ),
    );
  }
}
