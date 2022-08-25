part of 'input_number_cubit.dart';

@immutable
class InputNumberState extends Equatable {
  final String? phoneNumber;
  final LoadStatus? loadStatus;
  final String? verificationIDReceived;
  final String error;

  const InputNumberState({
    this.phoneNumber = '',
    this.loadStatus,
    this.verificationIDReceived = '',
    this.error = '',
  });

  InputNumberState copyWith({
    String? phoneNumber,
    LoadStatus? loadStatus,
    String? verificationIDReceived,
    String? error,
  }) {
    return InputNumberState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      loadStatus: loadStatus ?? this.loadStatus,
      verificationIDReceived: verificationIDReceived ?? this.verificationIDReceived,
      error: error ?? this.error,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, loadStatus, verificationIDReceived, error,];
}
