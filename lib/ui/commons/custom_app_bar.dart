import 'package:flutter/material.dart';

import '../../common/app_text_styles.dart';

class AppBarCustom extends StatelessWidget {
  String? title;
  int? icCount;
  List<String>? image;
  VoidCallback? onTap;

  AppBarCustom({
    Key? key,
    this.title,
    this.icCount,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 47, right: 24, left: 25, bottom: 13),
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title!,
              style: AppTextStyle.blackS18.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          icCount != null
              ? SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: icCount!,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: onTap,
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Image.asset(
                        image![index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 12);
                },
              ),
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}
