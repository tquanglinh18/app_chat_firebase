part of 'home_app_cubit.dart';

class HomeAppState extends Equatable {
  final int selectedIndex;

  const HomeAppState({this.selectedIndex = 0});

  HomeAppState copyWith({
    int? selectedIndex,
  }) {
    return HomeAppState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];
}
