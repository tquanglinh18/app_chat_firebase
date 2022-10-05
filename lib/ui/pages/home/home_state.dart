part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int selectedIndex;

  const HomeState({this.selectedIndex = 0});

  HomeState copyWith({
    int? selectedIndex,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];
}
