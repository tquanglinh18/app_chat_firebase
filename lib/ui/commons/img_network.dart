

import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class ImgNetwork extends StatelessWidget {
  String urlImageNetwork;
  ImgNetwork({Key? key , required this.urlImageNetwork }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
        urlImageNetwork,
        fit: BoxFit.cover,
        errorBuilder: (
        context,
        error,
        stackTrace,
    ) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: AppColors.greyBG,
          ),
        ),
        child: const Icon(
          Icons.info_outline,
          color: AppColors.border,
        ),
      );
    }
    );
  }
}
