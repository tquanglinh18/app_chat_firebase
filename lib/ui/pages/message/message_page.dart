import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/custom_progress_hud.dart';
import 'package:flutter_base/ui/commons/datetime_formatter.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/commons/my_dialog.dart';
import 'package:flutter_base/ui/pages/message/common/build_item_option_message.dart';
import 'package:flutter_base/ui/pages/message/common/dialog/dialog_view_document.dart';
import 'package:flutter_base/ui/pages/message/common/reply_msg.dart';
import 'package:flutter_base/ui/pages/message/option/option_chat.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_text_styles.dart';
import '../../commons/flus_bar.dart';
import 'common/text_message.dart';
import 'message_cubit.dart';
import 'message_state.dart';

class MessagePage extends StatefulWidget {
  final String idConversion;
  final String nameConversion;
  final String imgPath;

  const MessagePage({
    Key? key,
    this.idConversion = '',
    this.nameConversion = '',
    this.imgPath = '',
  }) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late MessageCubit _cubit;
  TextEditingController controllerMsg = TextEditingController();
  late final CustomProgressHUD _customProgressHUD;
  final FocusNode _focusNode = FocusNode();
  late AutoScrollController controller;

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
    controller = AutoScrollController(
      viewportBoundaryGetter: () => const Rect.fromLTRB(18, 0, 0, 18),
      axis: Axis.vertical,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).focusColor,
      body: BlocBuilder<MessageCubit, MessageState>(
        bloc: _cubit,
        buildWhen: (pre, cur) => pre.hintInputMsg != cur.hintInputMsg,
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppBar,
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
                          return _listMsg(
                            state.listMessage,
                          );
                        }
                      },
                    ),
                  ),
                  state.hintInputMsg
                      ? _inputMessage
                      : SizedBox(
                          height: 95 + MediaQuery.of(context).padding.bottom,
                        ),
                ],
              ),
              _customProgressHUD,
            ],
          );
        },
      ),
    );
  }

  Widget get _buildAppBar {
    return AppBarWidget(
      title: widget.nameConversion,
      onBackPressed: Navigator.of(context).pop,
      showBackButton: true,
      colorIcon: Theme.of(context).iconTheme.color!,
      rightActions: [
        InkWell(
          onTap: () {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.WARNING,
              title: "Tính năng đang được cập nhật !",
            );
          },
          child: Image.asset(
            AppImages.icSearchMessage,
            color: Theme.of(context).iconTheme.color!,
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              useRootNavigator: true,
              useSafeArea: false,
              builder: (BuildContext context) => DialogViewDocument(
                imgPath: widget.imgPath,
                nameUser: widget.nameConversion,
                uid: widget.idConversion,
              ),
            );
            FocusScope.of(context).unfocus();
          },
          child: Image.asset(
            AppImages.icOption,
            color: Theme.of(context).iconTheme.color!,
          ),
        ),
      ],
    );
  }

  Widget _listMsg(List<MessageEntity> listMessage) {
    return ListView.builder(
      reverse: true,
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: listMessage.length,
      itemBuilder: (BuildContext context, int index) {
        return BlocBuilder<MessageCubit, MessageState>(
          bloc: _cubit,
          buildWhen: (pre, cur) => pre.hintInputMsg != cur.hintInputMsg,
          builder: (context, state) {
            MessageEntity messageEntity = listMessage[listMessage.length - 1 - index];
            return listMessage.isEmpty
                ? Container()
                : (messageEntity.replyMsg ?? "").isNotEmpty
                    ? ReplyMsg(
                        message: messageEntity.message ?? "",
                        isSent: messageEntity.icConversion == state.uidFireBase,
                        timer: (messageEntity.createdAt ?? "").isNotEmpty
                            ? messageEntity.createdAt?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ?? ''
                            : "",
                        textReply: messageEntity.replyMsg ?? "",
                        nameSend: messageEntity.nameSend ?? "",
                        nameReply: messageEntity.nameReply ?? '',
                        listDocument: messageEntity.document ?? [],
                      )
                    : TextMessage(
                        message: messageEntity.message ?? "",
                        isSent: messageEntity.icConversion == state.uidFireBase,
                        timer: (messageEntity.createdAt ?? "").isNotEmpty
                            ? messageEntity.createdAt?.formatToDisplay(formatDisplay: DateTimeFormater.eventHour) ?? ''
                            : "",
                        listDocumnet: messageEntity.document ?? [],
                        nameSend: messageEntity.nameSend ?? "",
                        nameConversion: widget.nameConversion,
                        isDarkModeMsg: Theme.of(context).hoverColor,
                        uid: widget.idConversion,
                        onLongPress: () {
                          _focusNode.unfocus();
                          _cubit.showInputMsg();
                          _cubit.setIndexMsg(listMessage.length - 1 - index);
                          showModalBottomSheet(
                            useRootNavigator: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.transparent,
                            builder: (contextBottomSheet) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: _optionMessage(
                                  contextBottomSheet,
                                  messageEntity.icConversion == state.uidFireBase,
                                ),
                              );
                            },
                          ).then(
                            (value) {
                              if (value == null) {
                                _cubit.showInputMsg();
                              }
                            },
                          );
                        },
                      );
          },
        );
      },
    );
  }

  Widget get _msgField {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).hoverColor,
      ),
      child: TextField(
        autofocus: true,
        controller: controllerMsg,
        focusNode: _focusNode,
        style: AppTextStyle.whiteS14.copyWith(
          color: Theme.of(context).iconTheme.color!,
        ),
        onChanged: (value) {
          _cubit.textInputChanged(value);
        },
        minLines: 1,
        maxLines: 3,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: InputBorder.none,
          hintText: "Typing the message...",
          hintStyle: AppTextStyle.black.copyWith(
            color: AppColors.hintTextColor,
          ),
        ),
      ),
    );
  }

  Widget get _inputMessage {
    return BlocConsumer<MessageCubit, MessageState>(
      bloc: _cubit,
      listenWhen: (pre, cur) =>
          pre.sendMsgLoadStatus != cur.sendMsgLoadStatus ||
          pre.replyLoadStatus != cur.replyLoadStatus ||
          pre.deleteLoadStatus != cur.deleteLoadStatus ||
          pre.listDocument != cur.listDocument,
      listener: (context, state) {
        if (state.sendMsgLoadStatus == LoadStatus.success || state.replyLoadStatus == LoadStatus.success) {
          controllerMsg.text = "";
        } else {
          if (state.sendMsgLoadStatus == LoadStatus.failure ||
              state.replyLoadStatus == LoadStatus.failure ||
              state.deleteLoadStatus == LoadStatus.failure) {
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
                color: Theme.of(context).hoverColor,
                borderRadius: state.isReplyMsg || state.listDocument.isNotEmpty
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                    : BorderRadius.zero,
              ),
              child: Column(
                children: [
                  state.listDocument.isNotEmpty
                      ? Visibility(
                          visible: state.sendMsgLoadStatus != LoadStatus.loading,
                          child: _isNotEmptyDocument,
                        )
                      : const SizedBox(),
                  state.isReplyMsg ? _isReplyMsg((state.listMessage[state.indexMsg!].message)!) : const SizedBox(),
                  Row(
                    children: [
                      state.listDocument.isNotEmpty || state.isReplyMsg
                          ? const SizedBox()
                          : _moreOptionMsg(
                              () {
                                state.listDocument.isNotEmpty
                                    ? DxFlushBar.showFlushBar(
                                        context,
                                        type: FlushBarType.WARNING,
                                        title: "Chỉ được chọn 1 File đính kèm!",
                                      )
                                    : _cubit.isSelected();
                              },
                            ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: _msgField,
                      ),
                      const SizedBox(width: 17),
                      _sendBtn(
                        isReplyMsg: state.isReplyMsg,
                        sendMsgLoadStatus: state.sendMsgLoadStatus != LoadStatus.loading,
                      )
                    ],
                  ),
                  _inputDocumnet(
                    isSelected: state.isSelected,
                      listDocument: state.listDocument
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _moreOptionMsg(Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        AppImages.icAddContact,
        color: AppColors.hintTextColor,
      ),
    );
  }

  Widget get _isNotEmptyDocument {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          BlocBuilder<MessageCubit, MessageState>(
            buildWhen: (pre, cur) => pre.listDocument != cur.listDocument,
            bloc: _cubit,
            builder: (context, state) {
              return SizedBox(
                height: 75,
                width: MediaQuery.of(context).size.width,
                child: _buildDocumentSelected,
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 15),
            height: 1,
            color: AppColors.hintTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBtnRemoveDocument({required int index}) {
    return InkWell(
      onTap: () {
        _cubit.removeImgSelected(index: index);
        controllerMsg.text = '';
      },
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundLight,
        ),
        child: const Icon(
          Icons.close,
          size: 15,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget get _buildDocumentSelected {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.listDocument != cur.listDocument,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: state.listDocument.first.type == TypeDocument.FILE.name
              ? Image.asset(
                  AppImages.icFileDefault,
                  height: 50,
                  width: 50,
                  color: Theme.of(context).iconTheme.color,
                )
              : state.listDocument.first.type == TypeDocument.VIDEO.name
                  ? SizedBox(
                      height: 70,
                      width: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImgFile(urlFile: state.listDocument.first.pathThumbnail ?? ""),
                          const Icon(
                            Icons.play_circle_fill_outlined,
                            color: AppColors.hintTextColor,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width - 20,
                      child: Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.listDocument.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  height: 70,
                                  width: 100,
                                  child: ImgFile(urlFile: state.listDocument[index].path ?? ""),
                                ),
                                _buildBtnRemoveDocument(index: index),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 10);
                          },
                        ),
                      ),
                    ),
        );
      },
    );
  }

  Widget _isReplyMsg(String textMsgInput) {
    return Column(
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
                  textMsgInput,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 5),
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
    );
  }

  Widget _sendBtn({
    required bool isReplyMsg,
    required bool sendMsgLoadStatus,
  }) {
    return BlocConsumer<MessageCubit, MessageState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state.sendMsgLoadStatus == LoadStatus.loading) {
          _customProgressHUD.progress.show();
        } else if (state.sendMsgLoadStatus == LoadStatus.success) {
          _customProgressHUD.progress.dismiss();
        } else if (state.sendMsgLoadStatus == LoadStatus.failure) {
          DxFlushBar.showFlushBar(
            context,
            type: FlushBarType.WARNING,
            title: "Không gửi được tin nhắn !",
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<MessageCubit, MessageState>(
          bloc: _cubit,
          buildWhen: (pre, cur) => pre.listDocument != cur.listDocument || pre.textInput != cur.textInput,
          builder: (context, state) {
            return InkWell(
              onTap: () {
                if (state.listDocument.isNotEmpty || state.textInput.isNotEmpty) {
                  isReplyMsg == true
                      ? _cubit.replyMsg(
                          widget.idConversion,
                          controllerMsg.text,
                        )
                      : _cubit.sendMsg(
                          controllerMsg.text,
                          widget.idConversion,
                        );
                  state.isFirst = false;
                  _cubit.textInputChanged('');
                }
                if (state.isSelected == true) {
                  _cubit.isSelected();
                }
              },
              child: Image.asset(
                AppImages.icSentMessage,
                color: state.textInput.isNotEmpty | state.listDocument.isNotEmpty ? Colors.blueAccent : Colors.grey,
              ),
            );
          },
        );
      },
    );
  }

  Widget _inputDocumnet({
    required bool isSelected,
    required List<DocumentEntity> listDocument,
  }) {
    return OptionChat(
      isSelected: isSelected,
      listDocument: listDocument,
      onChooseImage: (file) {
        _cubit.addImage(
          path: file.map((e) => e.path).toList(),
        );
      },
      onChooseVideo: (listFile, file) {
        _cubit.addDocument(
          type: TypeDocument.VIDEO,
          path: listFile.first.path,
          pathThumbnail: file.path,
          name: listFile.first.path.split("/").last,
        );
      },
      onChooseDocument: (file) {
        _cubit.addDocument(
          type: TypeDocument.FILE,
          path: file.first.path,
          pathThumbnail: '',
          name: file.first.path.split('/').last,
        );
      },
    );
  }

  Widget _optionMessage(
    BuildContext contextBottomSheet,
    bool isSend,
  ) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.hintInputMsg != cur.hintInputMsg || pre.hintOptionMsg != cur.hintOptionMsg,
      builder: (context, state) {
        return Container(
          height: 90 + MediaQuery.of(context).padding.bottom,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.textBlack.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, -4), // Shadow position
              ),
            ],
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
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
}
