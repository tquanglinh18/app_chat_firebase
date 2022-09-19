import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  TextEditingController controllerMsg = TextEditingController(text: "");
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

  void getSizeAndPosition(_) async {
    try {
      await controller.scrollToIndex(_cubit.state.listMessage.length,
          preferPosition: AutoScrollPosition.middle, duration: const Duration(seconds: 5));
    } catch (e) {
      logger.e('getSizeAndPosition\n$e');
    }
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
                  Visibility(
                    visible: state.hintInputMsg,
                    child: _inputMessage,
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
    SchedulerBinding.instance.addPostFrameCallback(getSizeAndPosition);
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: listMessage.length,
      itemBuilder: (BuildContext context, int index) {
        return BlocBuilder<MessageCubit, MessageState>(
          bloc: _cubit,
          buildWhen: (pre, cur) => pre.hintOptionMsg != cur.hintOptionMsg || pre.hintInputMsg != cur.hintInputMsg,
          builder: (context, state) {
            return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              child: listMessage.isEmpty
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
                          isDarkModeMsg: Theme.of(context).hoverColor,
                          onLongPress: () {
                            _focusNode.unfocus();
                            _cubit.showInputMsg();
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: _optionMessage(
                                    contextBottomSheet,
                                    listMessage[index].icConversion == state.uidFireBase,
                                  ),
                                );
                              },
                            );
                          },
                        ),
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
          pre.deletLoadStatus != cur.deletLoadStatus ||
          pre.listDocument != cur.listDocument,
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
        if (state.listDocument.isNotEmpty) {
          _cubit.isSelected();
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
                  state.isReplyMsg ? _isReplyMsg((state.listMessage[state.indexMsg!].message)!) : const SizedBox(),
                  state.listDocument.isNotEmpty ? _isNotEmptyDocument : const SizedBox(),
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
                        state.isReplyMsg,
                        state.sendMsgLoadStatus != LoadStatus.loading,
                      )
                    ],
                  ),
                  _inputDocumnet(state.isSelected),
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
    return Column(
      children: [
        BlocBuilder<MessageCubit, MessageState>(
          bloc: _cubit,
          builder: (context, state) {
            return SizedBox(
              height: 75,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  _buildDocumentSelected(
                    typeDocument: state.listDocument.first.type ?? '',
                    urlFile: state.listDocument.first.type == TypeDocument.VIDEO.toTypeDocument
                        ? state.listDocument.first.pathThumbnail!
                        : state.listDocument.first.path!,
                  ),
                  _buildBtnRemoveDocument,
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
    );
  }

  Widget get _buildBtnRemoveDocument {
    return InkWell(
      onTap: () {
        _cubit.removeImgSelected();
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

  Widget _buildDocumentSelected({
    required String typeDocument,
    required String urlFile,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 5, right: 5),
      child: Column(
        children: [
          typeDocument == TypeDocument.FILE.name
              ? Image.asset(
                  AppImages.icFileDefault,
                  height: 50,
                  width: 50,
                )
              : typeDocument == TypeDocument.VIDEO.name
                  ? SizedBox(
                      height: 70,
                      width: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImgFile(urlFile: urlFile),
                          const Icon(
                            Icons.play_circle_fill_outlined,
                            color: AppColors.hintTextColor,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 70,
                      width: 100,
                      child: ImgFile(urlFile: urlFile),
                    ),
        ],
      ),
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
    );
  }

  Widget _sendBtn(
    bool isReplyMsg,
    bool sendMsgLoadStatus,
  ) {
    return InkWell(
      onTap: () {
        isReplyMsg == true
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
        color: sendMsgLoadStatus ? Colors.blueAccent : Colors.grey,
      ),
    );
  }

  Widget _inputDocumnet(bool isSelected) {
    return OptionChat(
      isSelected: isSelected,
      onChooseImage: (file) {
        _cubit.addDocument(
          type: TypeDocument.IMAGE.toTypeDocument,
          path: file.first.path,
          pathThumbnail: '',
          name: file.first.path.split("/").last,
        );
      },
      onChooseVideo: (listFile, file) {
        _cubit.addDocument(
          type: TypeDocument.VIDEO.toTypeDocument,
          path: listFile.first.path,
          pathThumbnail: file.path,
          name: listFile.first.path.split("/").last,
        );
      },
      onChooseDocument: (file) {
        _cubit.addDocument(
          type: TypeDocument.FILE.toTypeDocument,
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
            boxShadow: const [
              BoxShadow(
                color: AppColors.btnColor,
                blurRadius: 10,
                offset: Offset(2, 0), // Shadow position
              ),
            ],
            color: Theme.of(context).focusColor,
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
                  _cubit.showInputMsg();
                },
                buttonType: ButtonType.ACTIVE,
              ),
              ItemOptioneMsg(
                iconItem: Icons.delete,
                title: 'Xóa, gỡ bỏ',
                onTap: () {
                  Navigator.of(contextBottomSheet).pop();
                  _cubit.deleteMsg(widget.idConversion);
                  _cubit.showInputMsg();
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
