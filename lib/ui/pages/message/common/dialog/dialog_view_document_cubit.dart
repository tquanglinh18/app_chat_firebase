import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/entities/message_entity.dart';
import '../../../../../models/enums/load_status.dart';
import '../../../../../network/fire_base_api.dart';

part 'dialog_view_document_state.dart';

class DialogViewDocumentCubit extends Cubit<DialogViewDocumentState> {
  DialogViewDocumentCubit() : super(const DialogViewDocumentState());

  getListDocument(String uid) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      List<MessageEntity> listMsg = [];
      List<DocumentEntity> listImg = [];
      List<DocumentEntity> listVideo = [];
      List<DocumentEntity> listFile = [];
      await FirebaseApi.getMessages(uid).then((value) => {
            if (value.isNotEmpty)
              {
                value.sort((a, b) => b.createdAt!.compareTo(a.createdAt!)),
                listMsg = value
                    .where((element) => (element.document ?? []).isNotEmpty && (element.nameReply ?? '').isEmpty)
                    .toList(),
                listMsg.forEach((element) {
                  switch ((element.document ?? []).first.type) {
                    case "IMAGE":
                      for (int i = 0; i < (element.document ?? []).length; i++) {
                        listImg.add((element.document ?? [])[i]);
                      }
                      return;
                    case "VIDEO":
                      listVideo.add((element.document ?? []).first);
                      return;
                    case "FILE":
                      listFile.add((element.document ?? []).first);
                      return;
                  }
                }),
                emit(state.copyWith(
                  loadStatus: LoadStatus.success,
                  listImg: listImg,
                  listVideo: listVideo,
                  listFile: listFile,
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
