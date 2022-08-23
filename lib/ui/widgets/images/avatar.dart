import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/global/global_data.dart';
import 'package:uuid/uuid.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';
import '../../../common/app_text_styles.dart';

enum AvatarType { normal, rocketChat }

// ignore: must_be_immutable
class Avatar extends StatelessWidget {
  final String? url;
  final double? avatarSize;
  final VoidCallback? onSelectImage;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final double? strokeWidth;
  final String? defaultImg;
  final bool? needHttpHeader;
  final bool? isChatAvatar;
  final bool? isOnline;
  final AvatarType avatarType;
  final String firstCharacter; // use for type rocketChat

  Avatar({
    Key? key,
    this.url,
    this.onSelectImage,
    this.avatarSize = 60,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.strokeWidth,
    this.defaultImg,
    this.needHttpHeader = false,
    this.isChatAvatar = false,
    this.isOnline = false,
    this.avatarType = AvatarType.normal,
    this.firstCharacter = "",
  }) : super(key: key);

  final ValueNotifier<String> _keyImage = ValueNotifier(const Uuid().v4());
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (url != null && url!.isNotEmpty) {
      widget = ValueListenableBuilder(
          valueListenable: _keyImage,
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize! / 2),
              child: CachedNetworkImage(
                key: GlobalKey(debugLabel: _keyImage.value),
                width: avatarSize,
                height: avatarSize,
                imageUrl: url!,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) {
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CircularProgressIndicator(
                      strokeWidth: strokeWidth ?? 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.greyBG),
                    ),
                  );
                },
                /* placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textRed),
                  ),
                ),*/
                errorWidget: (context, url, error) {
                  switch (avatarType) {
                    case AvatarType.normal:
                      if (url.isNotEmpty) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          _count++;
                          _keyImage.value = const Uuid().v4();
                        });
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: strokeWidth ?? 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.greyBG),
                          ),
                        );
                      } else {
                        return SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            AppImages.icAvatar,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    case AvatarType.rocketChat:
                      return Container(
                        color: AppColors.btnColor,
                        alignment: Alignment.center,
                        child: Text(firstCharacter.toUpperCase(), style: AppTextStyle.whiteS16Bold),
                      );
                  }
                },
              ),
            );
          });
    } else {
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize! / 2),
        child: Image.asset(
          defaultImg ?? AppImages.icAvatar,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
        ),
      );
    }

    return InkWell(
      onTap: onSelectImage,
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: borderWidth ?? 2,
            color: borderColor ?? AppColors.border,
          ),
          boxShadow: boxShadow ?? [],
        ),
        child: isChatAvatar!
            ? Stack(
                children: [
                  widget,
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Visibility(
                      visible: isOnline!,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.btnColor,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : widget,
      ),
    );
  }
}
