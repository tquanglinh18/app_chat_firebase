import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/custom_progress_hud.dart';
import 'package:flutter_base/ui/commons/datetime_formatter.dart';
import 'package:flutter_base/ui/commons/my_dialog.dart';
import 'package:flutter_base/ui/pages/message/common/build_item_option_message.dart';
import 'package:flutter_base/ui/pages/message/common/reply_msg.dart';
import 'package:flutter_base/ui/pages/message/option/option_chat.dart';
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
  final String idConversion;

  const ChatPage({
    Key? key,
    this.idConversion = '',
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
    _cubit.initData(widget.idConversion);
    FirebaseFirestore.instance.collection('user').doc(widget.idConversion).snapshots().listen(
          (event) {
        _cubit.realTimeFireBase(widget.idConversion);
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
                onBackPressed: Navigator
                    .of(context)
                    .pop,
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
                              return state.listMessage.isEmpty
                                  ? Container()
                                  : (state.listMessage[index].replyMsg ?? "").isNotEmpty
                                  ? ReplyMsg(
                                message: state.listMessage[index].message ?? "",
                                isSent: state.listMessage[index].icConversion == state.uidFireBase,
                                timer: (state.listMessage[index].createdAt ?? "").isNotEmpty
                                    ? state.listMessage[index].createdAt
                                    ?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ??
                                    ''
                                    : "",
                                textReply: state.listMessage[index].replyMsg ?? "",
                              )
                                  : TextMessage(
                                message: state.listMessage[index].message ?? "",
                                isSent: state.listMessage[index].icConversion == state.uidFireBase,
                                timer: (state.listMessage[index].createdAt ?? "").isNotEmpty
                                    ? state.listMessage[index].createdAt
                                    ?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ??
                                    ''
                                    : "",
                                onLongPress: () {
                                  _focusNode.unfocus();
                                  _cubit.setIndexMsg(index);
                                  _cubit.showOptionMsg();
                                  showModalBottomSheet(
                                    useRootNavigator: true,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Colors.transparent,
                                    builder: (contextBottomSheet) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10), color: Colors.white),
                                          child: _optionMessage(
                                            contextBottomSheet,
                                            state.listMessage[index].icConversion == state.uidFireBase,
                                          ));
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
      listenWhen: (pre, cur) =>
      pre.sendMsgLoadStatus != cur.sendMsgLoadStatus ||
          pre.replyLoadStatus != cur.replyLoadStatus ||
          pre.deletLoadStatus != cur.deletLoadStatus ||
          pre.isSelected != cur.isSelected,
      listener: (context, state) {
        if (state.sendMsgLoadStatus == LoadStatus.success || state.replyLoadStatus == LoadStatus.success) {
          controllerMsg.text = "";
        } else {
          if (state.sendMsgLoadStatus == LoadStatus.failure ||
              state.replyLoadStatus == LoadStatus.failure ||
              state.deletLoadStatus == LoadStatus.failure) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.ERROR,
              title: "Đã xảy ra lỗi",
            );
          }
        }
      },
      buildWhen: (pre, cur) =>
      pre.sendMsgLoadStatus != cur.sendMsgLoadStatus ||
          pre.isSelected != cur.isSelected ||
          pre.isReplyMsg != cur.isReplyMsg,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + MediaQuery
                  .of(context)
                  .padding
                  .bottom),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: state.isReplyMsg
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )
                    : BorderRadius.zero,
              ),
              child: Column(
                children: [
                  state.isReplyMsg
                      ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.reply,
                              color: AppColors.btnColor,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                (state.listMessage[state.indexMsg!].message)!,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _cubit.showReplyMsg();
                              },
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        height: 1,
                        color: AppColors.hintTextColor,
                      ),
                    ],
                  )
                      : const SizedBox(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _cubit.isSelected();
                        },
                        child: Image.asset(
                          AppImages.icAddContact,
                          color: AppColors.hintTextColor,
                        ),
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
                            maxLines: 3,
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
                          state.isReplyMsg == true
                              ? _cubit.replyMsg(widget.idConversion, controllerMsg.text)
                              : _cubit.sendMsg(
                            controllerMsg.text,
                            widget.idConversion,
                          );
                        },
                        child: Image.asset(
                          AppImages.icSentMessage,
                          color: state.sendMsgLoadStatus != LoadStatus.loading ? Colors.blueAccent : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  OptionChat(isSelected: state.isSelected,
                    onChooseVideo: (List<File> , File)
                    { [] },
                    onChooseDocument: (List<File>)
                    { },
                    callBackRecord: (Recording? record) {},),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _optionMessage(BuildContext contextBottomSheet, bool isSend) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: _cubit,
      builder: (context, state) {
        return Container(
          height: 90,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ItemOptioneMsg(
                iconItem: Icons.reply,
                title: 'Trả lời',
                onTap: () {
                  Navigator.of(contextBottomSheet).pop();
                  _cubit.showReplyMsg();
                },
                buttonType: ButtonType.ACTIVE,
              ),
              ItemOptioneMsg(
                iconItem: Icons.delete,
                title: 'Xóa, gỡ bỏ',
                onTap: () {
                  Navigator.of(contextBottomSheet).pop();
                  _cubit.deleteMsg(widget.idConversion);
                },
                buttonType: isSend ? ButtonType.ACTIVE : ButtonType.IN_ACTIVE,
              ),
            ],
          ),
        );
      },
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
