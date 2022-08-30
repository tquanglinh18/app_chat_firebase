part of 'verify_number_cubit.dart';

class VerifyNumberState extends Equatable {
  final String? idUser;
  final LoadStatus? loadStatus;
  final String error;

  const VerifyNumberState({
    this.idUser = '',
    this.loadStatus,
    this.error = '',
  });

  VerifyNumberState copyWith({
    String? idUser,
    LoadStatus? loadStatus,
    String? error,
  }) {
    return VerifyNumberState(
      idUser: idUser ?? this.idUser,
      loadStatus: loadStatus ?? this.loadStatus,
      error: error ?? this.error,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        idUser,
        loadStatus,
        error,
      ];
}
