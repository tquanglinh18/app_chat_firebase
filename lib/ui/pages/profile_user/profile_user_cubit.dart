import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../models/enums/load_status.dart';

part 'profile_user_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit() : super(const ProfileUserState());

  firstNameChanged(String firstName){
    emit(state.copyWith(firstName: firstName));
  }

  lastNameChanged(String lastName){
    emit(state.copyWith(lastName: lastName));
  }


}
