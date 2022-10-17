import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';

import '../../common/app_colors.dart';
import '../../generated/l10n.dart';

class DataEmpty extends StatelessWidget {
  final Color color;
  const DataEmpty({Key? key, this.color = AppColors.hintTextColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 50,
            color: color,
          ),
          const SizedBox(height: 15),
          Text(
            S.of(context).empty_data,
            style: AppTextStyle.greyS14.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
