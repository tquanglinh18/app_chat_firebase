import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/custom_progress_hud.dart';
import 'package:flutter_base/ui/commons/datetime_formatter.dart';
import 'package:flutter_base/ui/commons/my_dialog.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';
import '../../commons/flus_bar.dart';
import 'common/text_message.dart';
import 'message_cubit.dart';
import 'message_state.dart';

class ChatPage extends StatefulWidget {
  final String idUser;

  const ChatPage({
    Key? key,
    this.idUser = "mwgXrHE2CdX9XKcoBn51",
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late MessageCubit _cubit;
  TextEditingController controllerMsg = TextEditingController(text: "");
  late final CustomProgressHUD _customProgressHUD;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _cubit = MessageCubit();
    _cubit.initData(widget.idUser);
    FirebaseFirestore.instance.collection('user').doc(widget.idUser).snapshots().listen(
      (event) {
        _cubit.realTimeFireBase(widget.idUser);
      },
      onError: (error) => logger.d("Realtime $error"),
    );
    _customProgressHUD = MyDialog.buildProgressDialog(
      loading: true,
      color: Colors.red,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgrColorsChatPage,
      body: Stack(
        children: [
          Column(
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
                child: BlocConsumer<MessageCubit, MessageState>(
                  bloc: _cubit,
                  listenWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
                  listener: (context, state) {
                    if (state.loadStatus != LoadStatus.loading) {
                      _customProgressHUD.progress.dismiss();
                    }
                  },
                  buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus || pre.listMessage != cur.listMessage,
                  builder: (context, state) {
                    if (state.loadStatus == LoadStatus.loading) {
                      return Container();
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.listMessage.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BlocBuilder<MessageCubit, MessageState>(
                            bloc: _cubit,
                            buildWhen: (pre, cur) => pre.hintOptionMsg != cur.hintOptionMsg,
                            builder: (context, state) {
                              return TextMessage(
                                message: state.listMessage[index].message ?? "",
                                isSent: widget.idUser == "mwgXrHE2CdX9XKcoBn51",
                                timer: (state.listMessage[index].createdAt ?? "").isNotEmpty
                                    ? state.listMessage[index].createdAt
                                            ?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ??
                                        ''
                                    : "",
                                onLongPress: () {
                                  _focusNode.unfocus();
                                  _cubit.setIndexMsg(index);
                                  _cubit.showOptionMsg();
                                  showBottomSheet(
                                    context: context,
                                    builder: (contextBottomSheet) {
                                      return Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                          child: _optionMessage(contextBottomSheet));
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              _inputMessageField(),
            ],
          ),
          _customProgressHUD,
        ],
      ),
    );
  }

  Widget _inputMessageField() {
    return BlocConsumer<MessageCubit, MessageState>(
      bloc: _cubit,
      listenWhen: (pre, cur) => pre.sendMsgLoadStatus != cur.sendMsgLoadStatus,
      listener: (context, state) {
        if (state.sendMsgLoadStatus == LoadStatus.success) {
          controllerMsg.text = "";
        } else {
          if (state.sendMsgLoadStatus == LoadStatus.failure) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.ERROR,
              title: "Đã xảy ra lỗi",
            );
          }
        }
      },
      buildWhen: (pre, cur) => pre.sendMsgLoadStatus != cur.sendMsgLoadStatus,
      builder: (context, state) {
        return Container(
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
                    controller: controllerMsg,
                    focusNode: _focusNode,
                    style: AppTextStyle.blackS14.copyWith(),
                    minLines: 1,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                      hintText: "Typing the message...",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 17),
              InkWell(
                onTap: () {
                  _cubit.sendMsg(
                    controllerMsg.text,
                    widget.idUser,
                  );
                },
                child: Image.asset(
                  AppImages.icSentMessage,
                  color: state.sendMsgLoadStatus != LoadStatus.loading ? Colors.blueAccent : Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _optionMessage(BuildContext contextBottomSheet) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildItemOptionMessage(
                Icons.reply,
                'Trả lời',
                () {
                  Navigator.of(contextBottomSheet).pop();
                  _cubit.replyMsg(widget.idUser, controllerMsg.text);

                },
              ),
              buildItemOptionMessage(
                Icons.delete,
                'Xóa, gỡ bỏ',
                () {
                  Navigator.of(contextBottomSheet).pop();
                  _cubit.deleteMsg(widget.idUser);
                },
              ),
            ],
          ),
        ),
        BlocBuilder<MessageCubit, MessageState>(
          bloc: _cubit,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                _cubit.showOptionMsg();
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.btnColor,
              ),
            );
          },
        )
      ],
    );
  }

  Widget buildItemOptionMessage(IconData iconItem, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.hintTextColor,
            ),
            child: Icon(
              iconItem,
              size: 20,
              color: AppColors.btnColor,
            ),
          ),
          Text(
            title,
            style: AppTextStyle.blackS14.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}
