part of 'archives_document_cubit.dart';

@immutable
class ArchivesDocumentState extends Equatable {
  final int indexTypeDocument;
  final LoadStatus? loadStatus;
  final List<DocumentEntity> listDocumentVideo;
  final List<DocumentEntity> listDocumentFile;

  const ArchivesDocumentState({
    this.indexTypeDocument = 0,
    this.loadStatus,
    this.listDocumentVideo = const [],
    this.listDocumentFile = const [],
  });

  ArchivesDocumentState copyWith({
    int? indexTypeDocument,
    LoadStatus? loadStatus,
    List<MessageEntity>? listMsg,
    List<DocumentEntity>? listDocumentVideo,
    List<DocumentEntity>? listDocumentFile,
  }) {
    return ArchivesDocumentState(
      indexTypeDocument: indexTypeDocument ?? this.indexTypeDocument,
      loadStatus: loadStatus ?? this.loadStatus,
      listDocumentVideo: listDocumentVideo ?? this.listDocumentVideo,
      listDocumentFile: listDocumentFile ?? this.listDocumentFile,
    );
  }

  @override
// TODO: implement props
  List<Object?> get props => [
        indexTypeDocument,
        loadStatus,
        listDocumentVideo,
        listDocumentFile,
      ];
}
