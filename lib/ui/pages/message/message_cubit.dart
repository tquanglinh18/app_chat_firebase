import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/message/option/option_chat.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/fire_base_api.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(const MessageState());

  initData(String icConversion) async {
    try {
      String uidFireBase = "";
      String nameSend = '';
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      SharedPreferencesHelper.getNameUserLoginKey().then(
        (value) {
          nameSend = value;
        },
      );
      SharedPreferencesHelper.getUidFireBaseKey().then(
        (value) {
          uidFireBase = value;
        },
      );
      FirebaseApi.getMessages(icConversion).then(
        (value) {
          emit(
            state.copyWith(
              loadStatus: LoadStatus.success,
              listMessage: value,
              uidFireBase: uidFireBase,
              nameSend: nameSend,
            ),
          );
        },
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }

  sendMsg(
    String text,
    String icConversion,
  ) {
    try {
      emit(state.copyWith(sendMsgLoadStatus: LoadStatus.loading));
      final newMessage = MessageEntity(
        icConversion: state.uidFireBase,
        message: text,
        createdAt: DateTime.now().toUtc().toString(),
        document: state.listDocument,
        nameSend: state.nameSend,
      );
      List<MessageEntity> msgList = state.listMessage;
      msgList.add(newMessage);
      FirebaseApi.uploadMessage(icConversion, msgList).then((value) {
        if (value) {
          emit(state.copyWith(
            sendMsgLoadStatus: LoadStatus.success,
            listDocument: [],
          ));
        } else {
          emit(state.copyWith(sendMsgLoadStatus: LoadStatus.failure));
        }
      });
    } catch (e) {
      emit(state.copyWith(sendMsgLoadStatus: LoadStatus.failure));
    }
  }

  realTimeFireBase(String icConversion) {
    FirebaseApi.getMessages(icConversion).then(
      (value) {
        emit(state.copyWith(listMessage: value));
      },
    );
  }

  setIndexMsg(int index) {
    emit(state.copyWith(indexMsg: index));
  }

  deleteMsg(String icConversion) {
    emit(state.copyWith(deletLoadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = state.listMessage;
      listMsg.removeAt(state.indexMsg!);
      FirebaseApi.uploadMessage(icConversion, listMsg).then(
        (value) {
          if (value) {
            emit(state.copyWith(deletLoadStatus: LoadStatus.success));
          } else {
            emit(state.copyWith(deletLoadStatus: LoadStatus.failure));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(deletLoadStatus: LoadStatus.failure));
    }
  }

  replyMsg(String icConversion, String textReply) {
    emit(state.copyWith(replyLoadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = state.listMessage;
      MessageEntity msg = listMsg[state.indexMsg!];
      MessageEntity msgReply = MessageEntity(
        createdAt: DateTime.now().toUtc().toString(),
        icConversion: state.uidFireBase,
        message: msg.message,
        replyMsg: textReply,
        document: msg.document,
        nameSend: msg.nameSend,
        nameReply: state.nameSend,
      );
      listMsg.insert(listMsg.length, msgReply);
      FirebaseApi.uploadMessage(icConversion, listMsg).then(
        (value) {
          if (value) {
            emit(state.copyWith(
              replyLoadStatus: LoadStatus.success,
              isReplyMsg: false,
            ));
          } else {
            emit(state.copyWith(replyLoadStatus: LoadStatus.failure));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(replyLoadStatus: LoadStatus.failure));
    }
  }

  showReplyMsg() {
    emit(state.copyWith(isReplyMsg: !state.isReplyMsg, indexMsg: state.indexMsg));
  }

  showOptionMsg() {
    emit(state.copyWith(hintOptionMsg: !state.hintOptionMsg));
  }

  showInputMsg() {
    emit(state.copyWith(hintInputMsg: !state.hintInputMsg));
  }

  isSelected() {
    emit(state.copyWith(isSelected: !state.isSelected));
  }

  addDocument({
    required String type,
    required String path,
    required String pathThumbnail,
    required String name,
  }) {
    try {
      List<DocumentEntity> listDocument = List.from(state.listDocument);
      listDocument.add(
        DocumentEntity(
          type: type,
          path: path,
          pathThumbnail: pathThumbnail,
          name: name,
          nameSend: state.nameSend,
          createAt: DateTime.now().toUtc().toString(),
        ),
      );

      emit(state.copyWith(listDocument: listDocument));
    } catch (e) {
      print(e);
    }
  }

  removeImgSelected() {
    emit(state.copyWith(listDocument: [], ));
  }
}
