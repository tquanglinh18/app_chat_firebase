part of 'profile_user_cubit.dart';

@immutable
class ProfileUserState extends Equatable {
  final String? firstName;
  final String? lastName;
  final LoadStatus? loadStatus;
  final String error;

  const ProfileUserState({
    this.firstName = '',
    this.lastName = '',
    this.loadStatus,
    this.error = '',
  });

  ProfileUserState copyWith({
    String? firstName,
    String? lastName,
    LoadStatus? loadStatus,
    String? error,
  }) {
    return ProfileUserState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      loadStatus: loadStatus ?? this.loadStatus,
      error: error ?? this.error,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
    firstName,
    lastName,
    loadStatus,
    error,
  ];
}

