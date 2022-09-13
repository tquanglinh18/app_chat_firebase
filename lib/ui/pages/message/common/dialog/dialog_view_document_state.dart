part of 'dialog_view_document_cubit.dart';

class DialogViewDocumentState extends Equatable {
  final int indexTypeDocument;
  final LoadStatus? loadStatus;
  final List<DocumentEntity> listImg;
  final List<DocumentEntity> listVideo;
  final List<DocumentEntity> listFile;

  const DialogViewDocumentState({
    this.indexTypeDocument = 0,
    this.loadStatus,
    this.listImg = const [],
    this.listVideo = const [],
    this.listFile = const [],
  });

  DialogViewDocumentState copyWith({
    int? indexTypeDocument,
    LoadStatus? loadStatus,
    List<DocumentEntity>? listImg,
    List<DocumentEntity>? listVideo,
    List<DocumentEntity>? listFile,
  }) {
    return DialogViewDocumentState(
      indexTypeDocument: indexTypeDocument ?? this.indexTypeDocument,
      loadStatus: loadStatus ?? this.loadStatus,
      listImg: listImg ?? this.listImg,
      listVideo: listVideo ?? this.listVideo,
      listFile: listFile ?? this.listFile,
    );
  }

  @override
// TODO: implement props
  List<Object?> get props => [
        indexTypeDocument,
        loadStatus,
        listImg,
        listVideo,
        listFile,
      ];
}
