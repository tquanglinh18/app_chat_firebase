import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../models/entities/message_entity.dart';
import '../../../../../models/enums/load_status.dart';

part 'archives_document_state.dart';

class ArchivesDocumentCubit extends Cubit<ArchivesDocumentState> {
  ArchivesDocumentCubit() : super(const ArchivesDocumentState());

  isSelectedType(
    int isSelectedType,
    List<DocumentEntity> listMsgFile,
    List<DocumentEntity> listMsgVideo,
  ) {
    emit(state.copyWith(indexTypeDocument: isSelectedType));
    switch (isSelectedType) {
      case 1:
        return listDocumentFile(listMsgFile);
      case 2:
        return listDocumentVideo(listMsgVideo);
      default:
        return;
    }
  }

  listDocumentFile(List<DocumentEntity> listMsgFile) async {
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      List<DocumentEntity> listDocumentFile = [];
      if (listMsgFile.isEmpty) return;
      DocumentEntity modelFirst = DocumentEntity(
        path: listMsgFile[0].path,
        pathThumbnail: listMsgFile[0].pathThumbnail,
        name: listMsgFile[0].name,
        nameSend: listMsgFile[0].nameSend,
        createAt: listMsgFile[0].createAt,
        isHeader: true,
      );
      listDocumentFile.add(modelFirst);

      for (int i = 0; i < listMsgFile.length; i++) {
        if (i + 1 < listMsgFile.length) {
          if ((listMsgFile[i].createAt ?? " ").split(' ').first !=
              (listMsgFile[i + 1].createAt ?? '').split(' ').first) {
            DocumentEntity msg = DocumentEntity(
              path: listMsgFile[i + 1].path,
              pathThumbnail: listMsgFile[i + 1].pathThumbnail,
              name: listMsgFile[i + 1].name,
              nameSend: listMsgFile[i + 1].nameSend,
              createAt: listMsgFile[i + 1].createAt,
              isHeader: true,
            );

            listDocumentFile.add(listMsgFile[i]);
            listDocumentFile.add(msg);
          } else {
            listDocumentFile.add(listMsgFile[i]);
          }
        } else {
          listDocumentFile.add(listMsgFile[i]);
        }
      }
      emit(state.copyWith(listDocumentFile: listDocumentFile, loadStatus: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }

  listDocumentVideo(List<DocumentEntity> listMsgVideo) {
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      List<DocumentEntity> listDocumentVideo = [];
      if (listMsgVideo.isEmpty) return;
      DocumentEntity modelFirst = DocumentEntity(
        path: listMsgVideo[0].path,
        pathThumbnail: listMsgVideo[0].pathThumbnail,
        name: listMsgVideo[0].name,
        nameSend: listMsgVideo[0].nameSend,
        createAt: listMsgVideo[0].createAt,
        isHeader: true,
      );
      listDocumentVideo.add(modelFirst);

      for (int i = 0; i < listMsgVideo.length; i++) {
        if (i + 1 < listMsgVideo.length) {
          if ((listMsgVideo[i].createAt ?? " ").split(' ').first !=
              (listMsgVideo[i + 1].createAt ?? '').split(' ').first) {
            DocumentEntity msg = DocumentEntity(
              path: listMsgVideo[i + 1].path,
              pathThumbnail: listMsgVideo[i + 1].pathThumbnail,
              name: listMsgVideo[i + 1].name,
              nameSend: listMsgVideo[i + 1].nameSend,
              createAt: listMsgVideo[i + 1].createAt,
              isHeader: true,
            );

            listDocumentVideo.add(listMsgVideo[i]);
            listDocumentVideo.add(msg);
          } else {
            listDocumentVideo.add(listMsgVideo[i]);
          }
        } else {
          listDocumentVideo.add(listMsgVideo[i]);
        }
      }
      emit(state.copyWith(listDocumentVideo: listDocumentVideo, loadStatus: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }
}
