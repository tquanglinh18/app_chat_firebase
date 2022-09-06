import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base/models/entities/user_entity.dart';
import 'package:meta/meta.dart';

import '../../../database/share_preferences_helper.dart';
import '../../../models/enums/load_status.dart';
import '../../../network/fire_base_api.dart';

part 'profile_user_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit() : super(const ProfileUserState());

  firstNameChanged(String firstName) {
    emit(state.copyWith(firstName: firstName));
  }

  lastNameChanged(String lastName) {
    emit(state.copyWith(lastName: lastName));
  }

  getListUser() async {
    try {
      await FirebaseApi.getListUser().then((value) {
        emit(state.copyWith(listUser: value));
      });
    } catch (e) {}
  }

  uploadUser(String name, String phoneNumber) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      await SharedPreferencesHelper.getUidFireBaseKey().then(
        (uidFireBase) {
          List<UserEntity> listUserFireBase = state.listUser;
          bool isCheck = listUserFireBase.any((element) => element.uid == uidFireBase);
          if (isCheck) {
            int index = listUserFireBase.indexWhere((element) => element.uid == uidFireBase);
            if (index != -1) {
              UserEntity user = listUserFireBase[index];
              user.name = name;
              user.avatar = state.image;
              user.phoneNumber = phoneNumber;
            } else {
              listUserFireBase.add(UserEntity(
                name: name,
                uid: uidFireBase,
                avatar: state.image,
                phoneNumber: phoneNumber,
              ));
            }
          } else {
            listUserFireBase.add(UserEntity(
              name: name,
              uid: uidFireBase,
              avatar: state.image,
              phoneNumber: phoneNumber,
            ));
          }
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
