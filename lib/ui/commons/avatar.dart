import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class Avatar extends StatelessWidget {
  final String urlAvatar;
  final Color darkModeColor;

  const Avatar({Key? key, required this.urlAvatar, this.darkModeColor = AppColors.greyBgr,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(urlAvatar),
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 1,
                color: AppColors.greyBG,
              ),
            ),
            child: Icon(
              Icons.info_outline,
              color: darkModeColor,
            ),
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }
}
