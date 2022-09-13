import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/enums/load_status.dart';

import '../../../models/entities/message_entity.dart';

class MessageState extends Equatable {
  List<MessageEntity> listMessage;
  LoadStatus? loadStatus;
  LoadStatus? sendMsgLoadStatus;
  LoadStatus? deletLoadStatus;
  LoadStatus? replyLoadStatus;
  bool hintOptionMsg;
  bool isReplyMsg;
  int? indexMsg;
  String uidFireBase;
  bool isSelected;
  List<DocumentEntity> listDocument;
  String? nameSend;

  MessageState({
    this.listMessage = const [],
    this.loadStatus,
    this.sendMsgLoadStatus,
    this.deletLoadStatus,
    this.hintOptionMsg = false,
    this.replyLoadStatus,
    this.isReplyMsg = false,
    this.indexMsg,
    this.uidFireBase = "",
    this.isSelected = false,
    this.listDocument = const [],
    this.nameSend,
  });

  MessageState copyWith({
    List<MessageEntity>? listMessage,
    LoadStatus? loadStatus,
    LoadStatus? sendMsgLoadStatus,
    LoadStatus? deletLoadStatus,
    LoadStatus? replyLoadStatus,
    bool? hintOptionMsg,
    bool? isReplyMsg,
    int? indexMsg,
    String? uidFireBase,
    bool? isSelected,
    List<DocumentEntity>? listDocument,
    String? nameSend,
  }) {
    return MessageState(
      listMessage: listMessage ?? this.listMessage,
      loadStatus: loadStatus ?? this.loadStatus,
      sendMsgLoadStatus: sendMsgLoadStatus ?? this.sendMsgLoadStatus,
      deletLoadStatus: deletLoadStatus ?? this.deletLoadStatus,
      replyLoadStatus: replyLoadStatus ?? this.replyLoadStatus,
      hintOptionMsg: hintOptionMsg ?? this.hintOptionMsg,
      isReplyMsg: isReplyMsg ?? this.isReplyMsg,
      indexMsg: indexMsg ?? this.indexMsg,
      uidFireBase: uidFireBase ?? this.uidFireBase,
      isSelected: isSelected ?? this.isSelected,
      listDocument: listDocument ?? this.listDocument,
      nameSend: nameSend ?? this.nameSend,
    );
  }

  @override
  List<Object?> get props => [
        listMessage,
        loadStatus,
        sendMsgLoadStatus,
        deletLoadStatus,
        replyLoadStatus,
        hintOptionMsg,
        isReplyMsg,
        indexMsg,
        uidFireBase,
        isSelected,
        listDocument,
        nameSend,
      ];
}
