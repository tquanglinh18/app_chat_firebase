import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/entities/user_entity.dart';
import '../models/enums/load_status.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  String? idUser;

  AppCubit({
    this.idUser,
  }) : super(const AppState());

  void fetchProfile() {
    emit(state.copyWith(fetchProfileStatus: LoadStatus.loading));
  }

  void updateProfile(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void saveIdUser(String? idUser) {
    emit(state.copyWith(idUser: idUser));
  }

}
