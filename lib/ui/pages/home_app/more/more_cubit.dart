import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/entities/user_entity.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/network/fire_base_api.dart';

part 'more_state.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(const MoreState());

  initData() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      String uid = await SharedPreferencesHelper.getUidFireBaseKey();

      FirebaseApi.getListUser().then(
        (value) {
          int indexModel = value.indexWhere((element) => element.uid == uid);
          if (indexModel != -1) {
            UserEntity model = value[indexModel];
            emit(
              state.copyWith(
                name: model.name,
                avatar: model.avatar,
                phoneNumber: model.phoneNumber,
                loadStatus: LoadStatus.success,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }
}
