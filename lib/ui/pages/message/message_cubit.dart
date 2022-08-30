import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/datetime_formatter.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/fire_base_api.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageState());

  initData(String idUser) async {
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      FirebaseApi.getMessages(idUser).then((value) {
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
          listMessage: value,
        ));
      });
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }

  sendMsg(String text, String idUser) {
    try {
      emit(state.copyWith(sendMsgLoadStatus: LoadStatus.loading));
      final newMessage = MessageEntity(
        idUser: idUser,
        message: text,
        createdAt: DateTime.now().toUtc().toString(),
      );
      List<MessageEntity> msgList = state.listMessage;
      msgList.add(newMessage);
      FirebaseApi.uploadMessage(idUser, msgList).then((value) {
        if (value) {
          emit(state.copyWith(sendMsgLoadStatus: LoadStatus.success));
        } else {
          emit(state.copyWith(sendMsgLoadStatus: LoadStatus.failure));
        }
      });
    } catch (e) {
      emit(state.copyWith(sendMsgLoadStatus: LoadStatus.failure));
    }
  }

  realTimeFireBase(String idUser) {
    FirebaseApi.getMessages(idUser).then((value) {
      emit(state.copyWith(
        listMessage: value,
      ));
    });
  }

  setIndexMsg(int index) {
    emit(state.copyWith(indexMsg: index));
  }

  deleteMsg(String idUser) {
    emit(state.copyWith(deletLoadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = state.listMessage;
      listMsg.removeAt(state.indexMsg!);

      FirebaseApi.uploadMessage(idUser, listMsg).then(
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

  replyMsg(String idUser, String textReply) {
    ///Caanf idUser, index reply (state.index)
    /// list msg to state
    ///  model msg = listMsg[index]
    ///  msg.replyMsg = textReply
    ///  FirebaseApi.uploadMessage(idUser, listMsg)

    emit(state.copyWith(deletLoadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = state.listMessage;
      MessageEntity msg = listMsg[state.indexMsg!];
      msg.replyMsg = textReply;
      FirebaseApi.uploadMessage(idUser, listMsg).then(
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

  showOptionMsg() {
    emit(state.copyWith(hintOptionMsg: !state.hintOptionMsg));
  }
}
