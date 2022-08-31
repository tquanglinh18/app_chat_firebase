import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_base/common/app_images.dart';

import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/custom_progress_hud.dart';
import 'package:flutter_base/ui/commons/datetime_formatter.dart';
import 'package:flutter_base/ui/commons/my_dialog.dart';
import 'package:flutter_base/ui/pages/message/common/build_item_option_message.dart';
import 'package:flutter_base/ui/pages/message/common/reply_msg.dart';
import 'package:flutter_base/ui/pages/message/option/option_chat.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
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
  final String nameConversion;

  const ChatPage({
    Key? key,
    this.idConversion = '',
    this.nameConversion = '',
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late MessageCubit _cubit;
  TextEditingController controllerMsg = TextEditingController(text: "");
  late final CustomProgressHUD _customProgressHUD;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _controllerList = ScrollController();

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
                title: widget.nameConversion,
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
                      return _listMsg(state.listMessage);
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

  Widget _listMsg(List<MessageEntity> listMessage) {
    return ListView.builder(
      controller: _controllerList,
      padding: const EdgeInsets.all(16),
      itemCount: listMessage.length,
      itemBuilder: (BuildContext context, int index) {
        return BlocBuilder<MessageCubit, MessageState>(
          bloc: _cubit,
          buildWhen: (pre, cur) => pre.hintOptionMsg != cur.hintOptionMsg,
          builder: (context, state) {
            return listMessage.isEmpty
                ? Container()
                : (listMessage[index].replyMsg ?? "").isNotEmpty
                    ? ReplyMsg(
                        message: listMessage[index].message ?? "",
                        isSent: listMessage[index].icConversion == state.uidFireBase,
                        timer: (listMessage[index].createdAt ?? "").isNotEmpty
                            ? listMessage[index]
                                    .createdAt
                                    ?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ??
                                ''
                            : "",
                        textReply: listMessage[index].replyMsg ?? "",
                        nameSend: listMessage[index].nameSend ?? "",
                        nameReply: listMessage[index].nameReply ?? '',
                        listDocument: listMessage[index].document ?? [],
                      )
                    : TextMessage(
                        message: listMessage[index].message ?? "",
                        isSent: listMessage[index].icConversion == state.uidFireBase,
                        timer: (listMessage[index].createdAt ?? "").isNotEmpty
                            ? listMessage[index]
                                    .createdAt
                                    ?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ??
                                ''
                            : "",
                        listDocumnet: listMessage[index].document ?? [],
                        nameSend: listMessage[index].nameSend ?? "",
                        nameConversion: widget.nameConversion,

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
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                child: _optionMessage(
                                  contextBottomSheet,
                                  listMessage[index].icConversion == state.uidFireBase,
                                ),
                              );
                            },
                          );
                        },
                      );
          },
        );
      },
    );
  }

  Widget _inputMessageField() {
    return BlocConsumer<MessageCubit, MessageState>(
      bloc: _cubit,
      listenWhen: (pre, cur) =>
          pre.sendMsgLoadStatus != cur.sendMsgLoadStatus ||
          pre.replyLoadStatus != cur.replyLoadStatus ||
          pre.deletLoadStatus != cur.deletLoadStatus,
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
          pre.isReplyMsg != cur.isReplyMsg ||
          pre.listDocument != cur.listDocument,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: state.isReplyMsg || state.listDocument.isNotEmpty
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
                  state.listDocument.isNotEmpty
                      ? Column(
                          children: [
                            BlocBuilder<MessageCubit, MessageState>(
                              bloc: _cubit,
                              builder: (context, state) {
                                return SizedBox(
                                  height: 70,
                                  width: 100,
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 5, right: 5),
                                        child: Image.file(
                                          File(
                                            state.listDocument.first.type == TypeDocument.VIDEO.toTypeDocument
                                                ? state.listDocument.first.pathThumbnail!
                                                : state.listDocument.first.path!,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _cubit.removeImgSelected();
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle, color: AppColors.backgroundLight),
                                          child: const Icon(
                                            Icons.close,
                                            size: 15,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                              ? _cubit.replyMsg(
                                  widget.idConversion,
                                  controllerMsg.text,
                                )
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
                  OptionChat(
                    isSelected: state.isSelected,
                    onChooseImage: (file) {
                      _cubit.addDocument(
                        TypeDocument.IMAGE.toTypeDocument,
                        file.first.path,
                        '',
                      );
                    },
                    onChooseVideo: (listFile, file) {
                      _cubit.addDocument(
                        TypeDocument.VIDEO.toTypeDocument,
                        listFile.first.path,
                        file.path,
                      );
                    },
                  ),
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
