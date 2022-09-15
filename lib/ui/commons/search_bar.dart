import 'package:flutter/material.dart';

import '../../common/app_colors.dart';
import '../../common/app_text_styles.dart';

class SearchBar extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool isClose;
  final VoidCallback? onClose;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;

  const SearchBar({
    Key? key,
    this.hintText,
    this.controller,
    this.isClose = true,
    this.onClose,
    this.onChanged,
    this.onSubmit,
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
        onSubmitted: onSubmit,
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
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
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
