import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/network/fire_base_api.dart';
import 'package:flutter_base/ui/pages/message/type_document.dart';

import '../../../../models/entities/story_entity.dart';
import '../../../../models/entities/user_entity.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(const ChatsState());

  onSearchTextChanged(String? searchText) {
    emit(state.copyWith(searchText: searchText));
  }

  upStory() async {
    try {
      emit(state.copyWith(loadStatusUpStory: LoadStatus.loading));
      List<StoryEntity> listStory = state.listStory;
      int index = listStory.indexWhere((element) => element.uid == state.uid);
      if (index == -1) {
        listStory.insert(
            0,
            StoryEntity(
              listStory: [state.storyItem!],
              name: state.nameUserLogin,
              uid: state.uid,
            ));
      } else {
        StoryEntity str = listStory[index];
        List<StoryItemEntity> lstImage = List.from(str.listStory ?? []);
        lstImage.add(state.storyItem!);
        str.listStory = lstImage;
      }
      await FirebaseApi.upStory(listStory).then((value) {
        if (value) {
          emit(state.copyWith(loadStatusUpStory: LoadStatus.success));
        } else {
          emit(state.copyWith(loadStatusUpStory: LoadStatus.failure));
        }
      });
    } catch (e) {
      emit(state.copyWith(loadStatusUpStory: LoadStatus.failure));
    }
  }

  getStory() async {
    try {
      emit(state.copyWith(loadStatus: LoadStatus.loading));
      await FirebaseApi.getStory().then((value) {
        if (value.isNotEmpty) {
          for (int i = 0; i < value.length; i++) {
            if ((value[i].listStory ?? []).isNotEmpty) {
              List<StoryItemEntity> listStory = value[i].listStory ?? [];
              List<StoryItemEntity> listStoryNew = [];
              for (int j = 0; j < listStory.length; j++) {
                if (DateTime.parse(listStory[j].createdAt ?? "").isAfter(
                  DateTime.now().toUtc().subtract(const Duration(days: 1)),
                )) {
                  listStoryNew.add(listStory[j]);
                }
              }
              value[i].listStory = listStoryNew;
            }
          }
        }
        emit(state.copyWith(listStory: value, loadStatus: LoadStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure));
    }
  }

  getListUser() async {
    try {
      emit(state.copyWith(loadStatusGetUser: LoadStatus.loading));
      await FirebaseApi.getListUser().then((value) {
        emit(state.copyWith(loadStatusGetUser: LoadStatus.success, listUser: value));
      });
    } catch (e) {
      emit(state.copyWith(loadStatusGetUser: LoadStatus.failure));
    }
  }

  getDataLocal() async {
    await SharedPreferencesHelper.getNameUserLoginKey().then((value) {
      emit(state.copyWith(nameUserLogin: value));
    });

    await SharedPreferencesHelper.getUidFireBaseKey().then((value) {
      emit(state.copyWith(uid: value));
    });
  }

  setImage(String path) {
    FirebaseApi.uploadDocument(path, TypeDocument.IMAGE).then(
      (value) {
        if (value.isNotEmpty) {
          emit(
            state.copyWith(
              storyItem: StoryItemEntity(
                createdAt: DateTime.now().toUtc().toString(),
                urlImage: value,
              ),
            ),
          );
          upStory();
        }
      },
    );
  }

  realTimeFireBase() async {
    await FirebaseApi.getStory().then((value) {
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          if ((value[i].listStory ?? []).isNotEmpty) {
            List<StoryItemEntity> listStory = value[i].listStory ?? [];
            List<StoryItemEntity> listStoryNew = [];
            for (int j = 0; j < listStory.length; j++) {
              if (DateTime.parse(listStory[j].createdAt ?? "").isAfter(
                DateTime.now().toUtc().subtract(const Duration(days: 1)),
              )) {
                listStoryNew.add(listStory[j]);
              } else {}
            }
            value[i].listStory = listStoryNew;
          }
        }
      }
      emit(state.copyWith(listStory: value, loadStatus: LoadStatus.success));
    });
    await FirebaseApi.getListUser().then((value) {
      emit(state.copyWith(listUser: value));
    });
  }

  searchUser(String searchTetx) async {
    try {
      emit(state.copyWith(loadStatusGetUser: LoadStatus.loading));
      List<UserEntity> listUser = [];
      await FirebaseApi.getListUser().then((value) {
        int index = value.indexWhere((element) => (element.name ?? "").contains(searchTetx));
        if (index == -1) {
          listUser = [];
        } else {
          listUser = value.where((element) => (element.name ?? "").contains(searchTetx)).toList();
        }
        emit(state.copyWith(listUser: listUser, loadStatusGetUser: LoadStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(loadStatusGetUser: LoadStatus.failure));
    }
  }

  isClose() {
    emit(state.copyWith(isClose: !state.isClose));
  }
}
