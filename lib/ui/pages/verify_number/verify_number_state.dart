part of 'verify_number_cubit.dart';

class VerifyNumberState extends Equatable {
  final String? otpValue;
  final LoadStatus? loadStatus;
  final String error;

  const VerifyNumberState({
    this.otpValue = '',
    this.loadStatus,
    this.error = '',
  });

  VerifyNumberState copyWith({
    String? otpValue,
    LoadStatus? loadStatus,
    String? error,
  }) {
    return VerifyNumberState(
      otpValue: otpValue ?? this.otpValue,
      loadStatus: loadStatus ?? this.loadStatus,
      error: error ?? this.error,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [
        otpValue,
        loadStatus,
        error,
      ];
}
