import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/models/entities/user_entity.dart';

import '../../../database/share_preferences_helper.dart';
import '../../../models/enums/load_status.dart';
import '../../../network/fire_base_api.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  firstNameChanged(String firstName) {
    emit(state.copyWith(firstName: firstName));
  }

  lastNameChanged(String lastName) {
    emit(state.copyWith(lastName: lastName));
  }

  getListUser() async {
    try {
      await FirebaseApi.getListUser().then(
        (value) {
          emit(state.copyWith(listUser: value));
        },
      );
    } catch (e) {
      print(e);
    }
  }

  uploadUser(String name, String phoneNumber) async {
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      await SharedPreferencesHelper.getUidFireBaseKey().then(
        (uidFireBase) async {
          List<UserEntity> listUserFireBase = state.listUser;
          bool isCheck = listUserFireBase.any((element) => element.uid == uidFireBase);
          await FirebaseApi.urlImage(state.image).then((urlIamge) {
            if (isCheck) {
              int index = listUserFireBase.indexWhere((element) => element.uid == uidFireBase);
              if (index != -1) {
                UserEntity user = listUserFireBase[index];
                user.name = name;
                user.avatar = urlIamge;
                user.phoneNumber = phoneNumber;
              } else {
                listUserFireBase.add(
                  UserEntity(
                    name: name,
                    uid: uidFireBase,
                    avatar: urlIamge,
                    phoneNumber: phoneNumber,
                  ),
                );
              }
            } else {
              listUserFireBase.add(
                UserEntity(
                  name: name,
                  uid: uidFireBase,
                  avatar: urlIamge,
                  phoneNumber: phoneNumber,
                ),
              );
            }
          });
          FirebaseApi.uploadProfile(uidFireBase, listUserFireBase).then(
            (value) {
              if (value) {
                SharedPreferencesHelper.setNameUserLoginKey(name);
                emit(state.copyWith(loadStatus: LoadStatus.success));
              } else {
                emit(state.copyWith(loadStatus: LoadStatus.failure));
              }
            },
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }

  isHide() {
    emit(state.copyWith(isHide: !state.isHide));
  }

  setImage(String path) {
    emit(state.copyWith(image: path));
  }
}
