import 'package:equatable/equatable.dart';

import '../../../../../models/entities/story_entity.dart';

class ViewStoryState extends Equatable {
  final int indexPageView;

  final List<StoryEntity> listStory;

  const ViewStoryState({
    this.indexPageView = 0,
    this.listStory = const [],
  });

  ViewStoryState copyWith({
    int? indexPageView,
    List<StoryEntity>? listStory,
  }) {
    return ViewStoryState(
      indexPageView: indexPageView ?? this.indexPageView,
      listStory: listStory ?? this.listStory,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        indexPageView,
        listStory,
      ];
}
