import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/ui/pages/message/image_message.dart';
import 'package:flutter_base/ui/pages/message/text_message.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_text_styles.dart';
import '../../commons/flus_bar.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBarWidget(
            title: "Name",
            onBackPressed: Navigator.of(context).pop,
            showBackButton: true,
            rightActions: [
              InkWell(
                onTap: () {
                  DxFlushBar.showFlushBar(
                    context,
                    type: FlushBarType.WARNING,
                    title: "Tính năng đang được cập nhật !",
                  );
                },
                child: Image.asset(AppImages.icSearchMessage),
              ),
              InkWell(
                onTap: () {
                  DxFlushBar.showFlushBar(
                    context,
                    type: FlushBarType.WARNING,
                    title: "Tính năng đang được cập nhật !",
                  );
                },
                child: Image.asset(AppImages.icOption),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  TextMessage(
                      message:
                          "Of course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your way",
                      isSent: true),
                  TextMessage(message: "K, I'm on my way", isSeen: false, isSent: false),
                  TextMessage(
                      message:
                          "Of course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your way",
                      isSent: true),
                  ImageMessage(
                      urlImage:
                          "https://static.vecteezy.com/system/resources/previews/005/520/089/original/cartoon-drawing-of-an-astronaut-vector.jpg",
                      message: "K, I'm on my way",
                      isSeen: true,
                      isSent: true),
                  TextMessage(message: "K, I'm on my way", isSeen: false, isSent: false),
                  ImageMessage(
                      urlImage:
                          "https://static.vecteezy.com/system/resources/previews/005/520/089/original/cartoon-drawing-of-an-astronaut-vector.jpg",
                      message: "K, I'm on my way",
                      isSeen: false,
                      isSent: false),
                  TextMessage(
                      message:
                          "Of course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your way",
                      isSent: true),
                  TextMessage(message: "K, I'm on my way", isSeen: false, isSent: false),
                  TextMessage(
                      message:
                          "Of course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your wayOf course, let me know if you're on your way",
                      isSent: true),
                ],
              ),
            ),
          ),
          _inputMessageField(),
        ],
      ),
    );
  }

  Widget _inputMessageField() {
    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border.symmetric(
          vertical: BorderSide(width: 1, color: AppColors.greyBG),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            AppImages.icAddContact,
            color: AppColors.hintTextColor,
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              //padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.titleColor,
              ),
              child: TextField(
                focusNode: FocusNode(),
                style: AppTextStyle.blackS14.copyWith(),
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  // contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  hintText: "Typing the message...",
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
}
