import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';

class ImgFile extends StatelessWidget {
  final String urlFile;
  final bool isSent;
  final String textMsgError;
  final bool documentIsVideo;
  final bool isBorderRadius;
  final bool isBorderSide;
  final Color? darkModeIconColor;
  final Color? isReplyColor;

  const ImgFile({
    Key? key,
    required this.urlFile,
    this.isSent = false,
    this.textMsgError = '',
    this.documentIsVideo = false,
    this.isBorderRadius = false,
    this.isBorderSide = false,
    this.darkModeIconColor,
    this.isReplyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(urlFile),
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: !isBorderRadius ? BorderRadius.circular(16) : BorderRadius.zero,
            border: Border.all(
              color: isBorderSide ? Colors.transparent : AppColors.hintTextColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: documentIsVideo ? const EdgeInsets.only(top: 120) : EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !documentIsVideo
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.info_outline,
                          color: !isSent ? darkModeIconColor : isReplyColor,
                        ),
                      )
                    : const SizedBox(),
                textMsgError.isNotEmpty
                    ? Center(
                        child: Text(
                          'Đã xảy ra lỗi \nVui lòng thử lại',
                          textAlign: TextAlign.center,
                          style: isSent
                              ? AppTextStyle.whiteS14.copyWith(
                            color: isReplyColor,
                          )
                              : AppTextStyle.blackS14.copyWith(
                                  color: darkModeIconColor,
                                ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }
}
