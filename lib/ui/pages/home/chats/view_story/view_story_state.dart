import 'package:equatable/equatable.dart';

class ViewStoryState extends Equatable {
  final int indexPageView;

  const ViewStoryState({
    this.indexPageView = 0,
  });

  ViewStoryState copyWith({
    int? indexPageView,
  }) {
    return ViewStoryState(
      indexPageView: indexPageView ?? this.indexPageView,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        indexPageView,
      ];
}
