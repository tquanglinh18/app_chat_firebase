import 'package:flutter_base/models/entities/story_entity.dart';
import 'package:flutter_base/network/fire_base_api.dart';
import 'package:flutter_base/ui/pages/home/chats/view_story/view_story_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewStoryCubit extends Cubit<ViewStoryState> {
  ViewStoryCubit() : super(const ViewStoryState());

  changeIndexPage(int index) {
    emit(state.copyWith(indexPageView: index));
  }
}