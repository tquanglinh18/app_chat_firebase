part of 'archives_document_cubit.dart';

@immutable
class ArchivesDocumentState extends Equatable {
  final int indexTypeDocument;
  final LoadStatus? loadStatus;
  final List<MessageEntity> listMsg;
  final List<DocumentEntity> listImg;
  final List<DocumentEntity> listVideo;
  final List<DocumentEntity> listDocumentVideo;
  final List<DocumentEntity> listDocumentFile;

  const ArchivesDocumentState({
    this.indexTypeDocument = 0,
    this.loadStatus,
    this.listMsg = const [],
    this.listImg = const [],
    this.listVideo = const [],
    this.listDocumentVideo = const [],
    this.listDocumentFile = const [],
  });

  ArchivesDocumentState copyWith({
    int? indexTypeDocument,
    LoadStatus? loadStatus,
    List<MessageEntity>? listMsg,
    List<DocumentEntity>? listImg,
    List<DocumentEntity>? listVideo,
    List<DocumentEntity>? listDocumentVideo,
    List<DocumentEntity>? listDocumentFile,
  }) {
    return ArchivesDocumentState(
      indexTypeDocument: indexTypeDocument ?? this.indexTypeDocument,
      loadStatus: loadStatus ?? this.loadStatus,
      listMsg: listMsg ?? this.listMsg,
      listImg: listImg ?? this.listImg,
      listVideo: listVideo ?? this.listVideo,
      listDocumentVideo: listDocumentVideo ?? this.listDocumentVideo,
      listDocumentFile: listDocumentFile ?? this.listDocumentFile,
    );
  }

  @override
// TODO: implement props
  List<Object?> get props => [
        indexTypeDocument,
        loadStatus,
        listMsg,
        listImg,
        listVideo,
        listDocumentVideo,
        listDocumentFile,
      ];
}
