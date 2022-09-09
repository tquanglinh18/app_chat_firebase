import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'archives_document_state.dart';

class ArchivesDocumentCubit extends Cubit<ArchivesDocumentState> {
  ArchivesDocumentCubit() : super(ArchivesDocumentState());

  isSelectedType(int isSelectedType){
    emit(state.copyWith(indexTypeDocument: isSelectedType));
  }
}
