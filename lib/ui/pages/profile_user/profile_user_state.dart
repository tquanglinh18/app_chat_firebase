part of 'profile_user_cubit.dart';

@immutable
class ProfileUserState extends Equatable {
  final String? firstName;
  final String? lastName;
  final LoadStatus? loadStatus;
  final String error;
  final List<UserEntity> listUser;

  const ProfileUserState({
    this.firstName = '',
    this.lastName = '',
    this.loadStatus,
    this.error = '',
    this.listUser = const [],
  });

  ProfileUserState copyWith({
    String? firstName,
    String? lastName,
    LoadStatus? loadStatus,
    String? error,
    List<UserEntity>? listUser,
  }) {
    return ProfileUserState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      loadStatus: loadStatus ?? this.loadStatus,
      error: error ?? this.error,
      listUser: listUser ?? this.listUser,
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
      ];
}
