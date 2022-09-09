part of 'archives_document_cubit.dart';

@immutable
class ArchivesDocumentState extends Equatable {
  int indexTypeDocument;

  ArchivesDocumentState({
    this.indexTypeDocument = 0,
  });

  ArchivesDocumentState copyWith({
    int? indexTypeDocument,
  }) {
    return ArchivesDocumentState(
      indexTypeDocument: indexTypeDocument ?? this.indexTypeDocument,
    );
  }

  @override
// TODO: implement props
  List<Object?> get props => [
        indexTypeDocument,
      ];
}
