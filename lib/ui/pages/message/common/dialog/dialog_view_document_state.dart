part of 'dialog_view_document_cubit.dart';

@immutable
 class DialogViewDocumentState extends Equatable {

  final int indexTypeDocument;
  final LoadStatus? loadStatus;
  final List<MessageEntity> listImg;
  final List<MessageEntity> listVideo;
  final List<MessageEntity> listFile;

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
    List<MessageEntity>? listImg,
    List<MessageEntity>? listVideo,
    List<MessageEntity>? listFile,
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
