part of 'chats_cubit.dart';

@immutable
class ChatsState extends Equatable {
  final String? searchText;
  final LoadStatus? loadStatus;
  final List<StoryEntity> listStory;
  final LoadStatus? loadStatusGetUser;
  final List<UserEntity> listUser;
  final String image;
  final LoadStatus? loadStatusUpStory;
  final String nameUserLogin;
  final String uid;

  const ChatsState({
    this.searchText = '',
    this.loadStatus,
    this.listStory = const [],
    this.loadStatusGetUser,
    this.listUser = const [],
    this.image = '',
    this.loadStatusUpStory,
    this.nameUserLogin = '',
    this.uid = '',
  });

  ChatsState copyWith({
    String? searchText,
    LoadStatus? loadStatus,
    List<StoryEntity>? listStory,
    LoadStatus? loadStatusGetUser,
    List<UserEntity>? listUser,
    String? image,
    LoadStatus? loadStatusUpStory,
    String? nameUserLogin,
    String? uid,
  }) {
    return ChatsState(
      searchText: searchText ?? this.searchText,
      loadStatus: loadStatus ?? this.loadStatus,
      listStory: listStory ?? this.listStory,
      loadStatusGetUser: loadStatusGetUser ?? this.loadStatusGetUser,
      listUser: listUser ?? this.listUser,
      image: image ?? this.image,
      loadStatusUpStory: loadStatusUpStory ?? this.loadStatusUpStory,
      nameUserLogin: nameUserLogin ?? this.nameUserLogin,
      uid: uid ?? this.uid,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        searchText,
        loadStatus,
        listStory,
        loadStatusGetUser,
        listUser,
        image,
        loadStatusUpStory,
        nameUserLogin,
        uid,
      ];
}
