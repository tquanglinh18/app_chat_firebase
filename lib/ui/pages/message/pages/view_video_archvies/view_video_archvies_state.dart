part of 'view_video_archvies_cubit.dart';

class ViewVideoArchviesState extends Equatable {
  final bool isPlaying;

  const ViewVideoArchviesState({
    this.isPlaying = false,
  });

  ViewVideoArchviesState copyWith({
    bool? isPlaying,
  }) {
    return ViewVideoArchviesState(
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
      ];
}
