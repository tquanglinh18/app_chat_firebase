import 'package:flutter_base/models/entities/story_entity.dart';
import 'package:flutter_base/network/fire_base_api.dart';
import 'package:flutter_base/ui/pages/home/chats/view_story/view_story_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewStoryCubit extends Cubit<ViewStoryState> {
  ViewStoryCubit() : super(const ViewStoryState());

  changeIndexPage(int index) {
    emit(state.copyWith(indexPageView: index));
  }

  storyView(String uid) async {
    try {
      List<StoryItemEntity> listStory = [];
      await FirebaseApi.getStory().then((value) {
        StoryEntity storyEntity = value[value.indexWhere((element) => element.uid == uid)];
        final DateTime now = DateTime.now().toUtc();
        List<StoryItemEntity> list = storyEntity.listStory!.toList();
        for (int i = 0; i < list.length; i++) {
          final DateTime date = DateTime.parse(storyEntity.listStory![i].createdAt ?? "");
          if( now.subtract(const Duration( days:  1)).isBefore(date)){
            listStory.add(storyEntity.listStory![i]);
          }
        }
        emit(state.copyWith(listStory: listStory));
      });
    } catch (e) {
      print(e);
    }
  }
}