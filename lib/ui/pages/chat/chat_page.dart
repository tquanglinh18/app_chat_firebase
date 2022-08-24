import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';

import '../../../common/app_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgrColorsChatPage,
      body: Column(
        children: [
          AppBarWidget(
            title: "Name",
            onBackPressed: Navigator.of(context).pop,
            showBackButton: true,
            rightActions: [
              Image.asset(AppImages.icSearchMessage),
              Image.asset(AppImages.icOption),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _message(
                      urlImage:
                          "https://www.humanesociety.org/sites/default/files/styles/1240x698/public/2020-07/kitten-510651.jpg?h=f54c7448&itok=ZhplzyJ9",
                      message: "Of course, let me know if you're on your way",
                      isSent: true),
                  _message(message: "K, I'm on my way", isSeen: false, isSent: false),
                ],
              ),
            ),
          ),
          inputMessageField(),
        ],
      ),
    );
  }

  Widget inputMessageField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 33),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.symmetric(
          vertical: BorderSide(width: 1, color: AppColors.greyBG),
        ),
      ),
      height: 84,
      child: Row(
        children: [
          Image.asset(
            AppImages.icAddContact,
            color: AppColors.hintTextColor,
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.titleColor,
              ),
              child: TextField(
                focusNode: FocusNode(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 17),
          Image.asset(AppImages.icSentMessage),
        ],
      ),
    );
  }

  Widget _message({String? urlImage, String? message, bool? isSent = false, bool? isSeen = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: (isSent != true) ? AppColors.backgroundLight : AppColors.btnColor,
          borderRadius: (isSent != true)
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10))
              : const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
      child: Column(
        crossAxisAlignment: (isSent != true) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          urlImage != null
              ? SizedBox(
                  height: 150,
                  width: 246,
                  child: AspectRatio(
                    aspectRatio: 246 / 150,
                    child: Image.network(urlImage),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 4),
          Text(
            message!,
            style: (isSent != true)
                ? AppTextStyle.blackS14.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  )
                : AppTextStyle.whiteS14.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            (isSeen != true) ? "time" : "time • Read",
            style: (isSent != true)
                ? AppTextStyle.blackS14.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  )
                : AppTextStyle.whiteS14.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
          ),
        ],
      ),
    );
  }
}
