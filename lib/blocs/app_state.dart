part of 'app_cubit.dart';

class AppState extends Equatable {
  final UserEntity? user;
  final LoadStatus fetchProfileStatus;
  final LoadStatus signOutStatus;
  final String idUser;

  const AppState({
    this.user,
    this.fetchProfileStatus = LoadStatus.initial,
    this.signOutStatus = LoadStatus.initial,
    this.idUser = '',
  });

  AppState copyWith({
    UserEntity? user,
    LoadStatus? fetchProfileStatus,
    LoadStatus? signOutStatus,
    String? idUser,
  }) {
    return AppState(
      user: user ?? this.user,
      fetchProfileStatus: fetchProfileStatus ?? this.fetchProfileStatus,
      signOutStatus: signOutStatus ?? this.signOutStatus,
      idUser: idUser ?? this.idUser,
    );
  }

  AppState removeUser() {
    return AppState(
      user: user,
      fetchProfileStatus: fetchProfileStatus,
      signOutStatus: signOutStatus,
      idUser: idUser,
    );
  }

  @override
  List<Object?> get props => [
        user,
        fetchProfileStatus,
        signOutStatus,
        idUser,
      ];
}
