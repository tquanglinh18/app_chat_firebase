import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view_video_archvies_state.dart';

class ViewVideoArchviesCubit extends Cubit<ViewVideoArchviesState> {
  ViewVideoArchviesCubit() : super(const ViewVideoArchviesState());
  
  isPlayingVideo(bool isPlaying) {
    emit(state.copyWith(isPlaying: isPlaying));
  }
}
