import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';

class SearchBar extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  bool isClose;
  VoidCallback? onClose;
  void Function(String)? onChanged;

  SearchBar({
    Key? key,
    this.hintText,
    this.controller,
    this.isClose = true,
    this.onClose,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 36,
      child: TextField(
        controller: controller,
        maxLines: 1,
        style: const TextStyle(fontSize: 17),
        textAlignVertical: TextAlignVertical.center,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          suffixIcon: Visibility(
            visible: isClose,
            child: InkWell(
              onTap: onClose,
              child: const Icon(
                Icons.close,
                color: AppColors.hintTextColor,
              ),
            ),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.hintTextColor,
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30))),
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          contentPadding: EdgeInsets.zero,
          hintText: hintText ?? "Search",
          hintStyle: AppTextStyle.greyS14.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.hintTextColor,
          ),
        ),
      ),
    );
  }
}
