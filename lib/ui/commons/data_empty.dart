
import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class DataEmpty extends StatelessWidget {
  const DataEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.info_outline,
            size: 50,
            color: AppColors.hintTextColor,
          ),
          SizedBox(height: 15),
          Text(
            "Không có dữ liệu!",
          ),
        ],
      ),
    );
  }
}
