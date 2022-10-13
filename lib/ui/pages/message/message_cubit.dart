import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/message_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/fire_base_api.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageState());

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

  Future<bool> convertUrl(List<DocumentEntity> documentEntity) async {
    bool isCheck = false;
    try {
      for (int i = 0; i < documentEntity.length; i++) {
        await FirebaseApi.uploadDocument(documentEntity[i].path ?? "", TypeDocument.IMAGE).then((value) {
          documentEntity[i].path = value;
          isCheck = (i == (documentEntity.length - 1));
        });
      }
      if (isCheck) {
        emit(state.copyWith(listDocument: documentEntity));
      }
      return isCheck;
    } catch (e) {
      return isCheck;
    }
  }

  sendMsg(
    String text,
    String icConversion,
  ) {
    try {
      emit(state.copyWith(sendMsgLoadStatus: LoadStatus.loading));
      if (state.listDocument.isNotEmpty) {
        List<DocumentEntity> documentEntity = state.listDocument;
        switch (TypeDocumentExtension.fromTypeDocument(documentEntity.first.type ?? "")) {
          case TypeDocument.IMAGE:
            convertUrl(documentEntity).then((value) {
              if (value) {
                sendNewMessage(text, icConversion);
              }
            });

            break;
          case TypeDocument.VIDEO:
            FirebaseApi.uploadDocument(documentEntity.first.path ?? "", TypeDocument.VIDEO).then((urlLink) {
              FirebaseApi.uploadDocument(documentEntity.first.pathThumbnail ?? "", TypeDocument.VIDEO)
                  .then((urlLinkThumnail) {
                documentEntity.first.path = urlLink;
                documentEntity.first.pathThumbnail = urlLinkThumnail;
                sendNewMessage(text, icConversion);
              });
            });
            break;
          case TypeDocument.FILE:
            FirebaseApi.uploadDocument(documentEntity.first.path ?? "", TypeDocument.FILE).then((value) {
              documentEntity.first.path = value;
              sendNewMessage(text, icConversion);
            });
            break;
          default:
            break;
        }
      } else {
        sendNewMessage(text, icConversion);
      }
    } catch (e) {
      emit(state.copyWith(sendMsgLoadStatus: LoadStatus.failure));
    }
  }

  sendNewMessage(
    String text,
    String icConversion,
  ) {
    try {
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
    emit(state.copyWith(deleteLoadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = state.listMessage;
      listMsg.removeAt(state.indexMsg!);
      FirebaseApi.uploadMessage(icConversion, listMsg).then(
        (value) {
          if (value) {
            emit(state.copyWith(deleteLoadStatus: LoadStatus.success));
          } else {
            emit(state.copyWith(deleteLoadStatus: LoadStatus.failure));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(deleteLoadStatus: LoadStatus.failure));
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
    required TypeDocument type,
    required String path,
    required String pathThumbnail,
    required String name,
  }) {
    try {
      List<DocumentEntity> listDocument = List.from(state.listDocument);
      listDocument.add(
        DocumentEntity(
          type: type.toTypeDocument,
          path: path,
          pathThumbnail: pathThumbnail,
          name: name,
          nameSend: state.nameSend,
          createAt: DateTime.now().toUtc().toString(),
        ),
      );
      emit(state.copyWith(listDocument: listDocument));
    } catch (e) {
      logger.e(e);
    }
  }

  removeImgSelected({required int index}) {
    List<DocumentEntity> documentEntity = List.from(state.listDocument);
    documentEntity.removeAt(index);
    emit(state.copyWith(listDocument: documentEntity));
  }

  addImage({
    required List<String> path,
  }) {
    try {
      List<DocumentEntity> list = List.from(state.listDocument);
      for (var i in path) {
        list.add(DocumentEntity(
          type: TypeDocument.IMAGE.name,
          path: i,
          pathThumbnail: '',
          name: i.split("/").last,
          nameSend: state.nameSend,
          createAt: DateTime.now().toUtc().toString(),
        ));
      }
      emit(state.copyWith(listDocument: list));
    } catch (e) {
      logger.e(e);
    }
  }

  textInputChanged(String text) {
    emit(state.copyWith(textInput: text));
  }
}
