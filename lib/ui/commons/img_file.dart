
import 'dart:io';

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class ImgFile extends StatelessWidget {
  String urlFile;
  ImgFile({Key? key, required this.urlFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(urlFile),
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return const Icon(
          Icons.info_outline,
          color: AppColors.border,
        );
      },
      fit: BoxFit.cover,
    );
  }
}
