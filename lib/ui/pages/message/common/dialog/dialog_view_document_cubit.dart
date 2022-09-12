import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../models/entities/message_entity.dart';
import '../../../../../models/enums/load_status.dart';
import '../../../../../network/fire_base_api.dart';

part 'dialog_view_document_state.dart';

class DialogViewDocumentCubit extends Cubit<DialogViewDocumentState> {
  DialogViewDocumentCubit() : super(const DialogViewDocumentState());

  getListDocument(String uid) {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = [];
      FirebaseApi.getMessages(uid).then((value) => {
            if (value.isNotEmpty)
              {
                listMsg = value.where((element) => (element.document ?? []).isNotEmpty).toList(),
                emit(state.copyWith(
                  loadStatus: LoadStatus.success,
                  listImg: listMsg.where((element) => (element.document ?? []).first.type == "IMAGE").toList(),
                  listVideo: listMsg.where((element) => (element.document ?? []).first.type == "VIDEO").toList(),
                  listFile: listMsg.where((element) => (element.document ?? []).first.type == "FILE").toList(),
                ))
              }
            else
              {
                emit(state.copyWith(loadStatus: LoadStatus.failure)),
              }
          });
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }
}
