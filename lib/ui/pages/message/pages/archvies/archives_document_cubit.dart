import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

import '../../../../../models/entities/message_entity.dart';
import '../../../../../models/enums/load_status.dart';
import '../../../../../network/fire_base_api.dart';

part 'archives_document_state.dart';

class ArchivesDocumentCubit extends Cubit<ArchivesDocumentState> {
  ArchivesDocumentCubit() : super(ArchivesDocumentState());

  isSelectedType(int isSelectedType) {
    emit(state.copyWith(indexTypeDocument: isSelectedType));
  }

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
                  listImg: listMsg.where((element) => element.type == "IMAGE").first.document,
                  listVideo: listMsg.where((element) => element.type == "VIDEO").first.document,
                  listFile: listMsg.where((element) => element.type == "FILE").first.document,
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
