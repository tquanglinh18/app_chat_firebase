import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';

class SearchBar extends StatelessWidget {
  String? hintText;
  SearchBar({Key? key, this.hintText,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      height: 36,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.titleColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            color: AppColors.hintTextColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText ?? "Search",
                hintStyle: AppTextStyle.greyS14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.hintTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
