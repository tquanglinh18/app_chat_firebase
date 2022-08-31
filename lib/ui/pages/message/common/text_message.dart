import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/ui/pages/message/pages/play_video.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';

class TextMessage extends StatelessWidget {
  String? message;
  bool? isSent = false;
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
            Text(
              nameSend,
              style: AppTextStyle.greyS12.copyWith(fontSize: 10),
            ),
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
                          ? Image.file(File(listDocumnet.first.path!))
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PlayVideo(
                                      nameConversion: nameConversion,
                                      path: listDocumnet.first.path!,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: Image.file(
                                      File(listDocumnet.first.pathThumbnail ?? ""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.play_circle_fill_outlined,
                                    size: 50,
                                  ),
                                ],
                              ),
                            )
                      : const SizedBox(),
                  const SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }
}
