part of 'profile_user_cubit.dart';

@immutable
class ProfileUserState extends Equatable {
  final String? firstName;
  final String? lastName;
  final LoadStatus? loadStatus;
  final String error;
  final List<UserEntity> listUser;
  final String image;
  final bool isHide;

  const ProfileUserState({
    this.firstName = '',
    this.lastName = '',
    this.loadStatus,
    this.error = '',
    this.listUser = const [],
    this.image = '',
    this.isHide = false,
  });

  ProfileUserState copyWith({
    String? firstName,
    String? lastName,
    LoadStatus? loadStatus,
    String? error,
    List<UserEntity>? listUser,
    String? image,
    bool? isHide,
  }) {
    return ProfileUserState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      loadStatus: loadStatus ?? this.loadStatus,
      error: error ?? this.error,
      listUser: listUser ?? this.listUser,
      image: image ?? this.image,
      isHide: isHide ?? this.isHide,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        firstName,
        lastName,
        loadStatus,
        error,
        listUser,
        image,
        isHide,
      ];
}
