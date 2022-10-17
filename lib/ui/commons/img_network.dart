import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/logger.dart';

import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';
import '../../generated/l10n.dart';

class ImgNetwork extends StatelessWidget {
  final String linkUrl;
  final bool isSent;
  final bool isReplyMsg;
  final String textMsgError;
  final bool documentIsVideo;
  final bool isBorderRadius;
  final bool isBorderSide;
  final Color? darkModeIconColor;
  final Color? isReplyColor;

  const ImgNetwork({
    Key? key,
    required this.linkUrl,
    this.isSent = false,
    this.isReplyMsg = false,
    this.textMsgError = '',
    this.documentIsVideo = false,
    this.isBorderRadius = false,
    this.isBorderSide = false,
    this.darkModeIconColor,
    this.isReplyColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: linkUrl,
      imageBuilder: (context, imageProvider) {
        return Image.network(
          linkUrl,
          errorBuilder: (
            context,
            errorr,
            stackTrace,
          ) {
            logger.e(errorr);
            return Container(
              decoration: BoxDecoration(
                borderRadius: !isBorderRadius ? BorderRadius.circular(16) : BorderRadius.zero,
                border: Border.all(
                  color: isBorderSide ? Colors.transparent : AppColors.hintTextColor,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: documentIsVideo ? const EdgeInsets.only(top: 90) : EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !documentIsVideo
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Icon(
                                Icons.info_outline,
                                color: !isSent
                                    ? darkModeIconColor
                                    : isReplyMsg
                                        ? AppColors.backgroundDark
                                        : AppColors.backgroundLight,
                              ),
                            )
                          : const SizedBox(),
                      textMsgError.isNotEmpty
                          ? Center(
                              child: Text(
                                S.of(context).error_message,
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
              ),
            );
          },
          fit: BoxFit.cover,
        );
      },
      placeholder: (context, url) => Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        logger.e(error);
        logger.e(linkUrl);
        return Container(
          decoration: BoxDecoration(
            borderRadius: !isBorderRadius ? BorderRadius.circular(16) : BorderRadius.zero,
            border: Border.all(
              color: isBorderSide ? Colors.transparent : AppColors.hintTextColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: documentIsVideo ? const EdgeInsets.only(top: 90) : EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !documentIsVideo
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.info_outline,
                          color: !isSent
                              ? darkModeIconColor
                              : isReplyMsg
                                  ? AppColors.backgroundDark
                                  : AppColors.backgroundLight,
                        ),
                      )
                    : const SizedBox(),
                textMsgError.isNotEmpty
                    ? Center(
                        child: Text(
                          S.of(context).error_message,
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
