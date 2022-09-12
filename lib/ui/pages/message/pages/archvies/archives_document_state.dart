part of 'archives_document_cubit.dart';

@immutable
class ArchivesDocumentState extends Equatable {
  final int indexTypeDocument;
  final LoadStatus? loadStatus;
  final List<MessageEntity> listMsg;
  final List<Document> listImg;
  final List<Document> listVideo;
  final List<Document> listFile;

  ArchivesDocumentState({
    this.indexTypeDocument = 0,
    this.loadStatus,
    this.listMsg = const [],
    this.listImg = const [],
    this.listVideo = const [],
    this.listFile = const [],
  });

  ArchivesDocumentState copyWith({
    int? indexTypeDocument,
    LoadStatus? loadStatus,
    List<MessageEntity>? listMsg,
    List<Document>? listImg,
    List<Document>? listVideo,
    List<Document>? listFile,
  }) {
    return ArchivesDocumentState(
      indexTypeDocument: indexTypeDocument ?? this.indexTypeDocument,
      loadStatus: loadStatus ?? this.loadStatus,
      listMsg: listMsg ?? this.listMsg,
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
        listMsg,
        listImg,
        listVideo,
        listFile,
      ];
}
