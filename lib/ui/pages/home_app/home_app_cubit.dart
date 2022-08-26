import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_app_state.dart';
class HomeAppCubit extends Cubit<HomeAppState> {
  HomeAppCubit() : super(const HomeAppState());

  onItemTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void initData() {
    emit(state.copyWith());
  }
}
