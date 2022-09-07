import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
class Avatar extends StatelessWidget {
  String urlAvatar;
  Avatar({Key? key, required this.urlAvatar }) : super(key: key);

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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: AppColors.greyBG,
              ),
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.border,
            ),
          ),
        );
      },
      fit: BoxFit.cover,
    );
  }
}
