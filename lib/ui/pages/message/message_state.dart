import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';

import '../../../models/entities/message_entity.dart';

class MessageState extends Equatable {
  final List<MessageEntity> listMessage;
  final LoadStatus? loadStatus;
  final LoadStatus? sendMsgLoadStatus;
  final LoadStatus? deleteLoadStatus;
  final LoadStatus? replyLoadStatus;
  final bool hintOptionMsg;
  final bool isReplyMsg;
  final int? indexMsg;
  final String uidFireBase;
  final bool isSelected;
  final List<DocumentEntity> listDocument;
  final String? nameSend;
  final bool hintInputMsg;
  bool isFirst;
  final String textInput;

  MessageState({
    this.listMessage = const [],
    this.loadStatus,
    this.sendMsgLoadStatus,
    this.deleteLoadStatus,
    this.hintOptionMsg = false,
    this.replyLoadStatus,
    this.isReplyMsg = false,
    this.indexMsg,
    this.uidFireBase = "",
    this.isSelected = false,
    this.listDocument = const [],
    this.nameSend,
    this.hintInputMsg = true,
    this.isFirst = false,
    this.textInput = '',
  });

  MessageState copyWith({
    List<MessageEntity>? listMessage,
    LoadStatus? loadStatus,
    LoadStatus? sendMsgLoadStatus,
    LoadStatus? deleteLoadStatus,
    LoadStatus? replyLoadStatus,
    bool? hintOptionMsg,
    bool? isReplyMsg,
    int? indexMsg,
    String? uidFireBase,
    bool? isSelected,
    List<DocumentEntity>? listDocument,
    String? nameSend,
    bool? hintInputMsg,
    bool? isFirst,
    String? textInput,
  }) {
    return MessageState(
      listMessage: listMessage ?? this.listMessage,
      loadStatus: loadStatus ?? this.loadStatus,
      sendMsgLoadStatus: sendMsgLoadStatus ?? this.sendMsgLoadStatus,
      deleteLoadStatus: deleteLoadStatus ?? this.deleteLoadStatus,
      replyLoadStatus: replyLoadStatus ?? this.replyLoadStatus,
      hintOptionMsg: hintOptionMsg ?? this.hintOptionMsg,
      isReplyMsg: isReplyMsg ?? this.isReplyMsg,
      indexMsg: indexMsg ?? this.indexMsg,
      uidFireBase: uidFireBase ?? this.uidFireBase,
      isSelected: isSelected ?? this.isSelected,
      listDocument: listDocument ?? this.listDocument,
      nameSend: nameSend ?? this.nameSend,
      hintInputMsg: hintInputMsg ?? this.hintInputMsg,
      isFirst: isFirst ?? this.isFirst,
      textInput: textInput ?? this.textInput,
    );
  }

  @override
  List<Object?> get props => [
        listMessage,
        loadStatus,
        sendMsgLoadStatus,
        deleteLoadStatus,
        replyLoadStatus,
        hintOptionMsg,
        isReplyMsg,
        indexMsg,
        uidFireBase,
        isSelected,
        listDocument,
        nameSend,
        hintInputMsg,
        isFirst,
        textInput,
      ];
}
