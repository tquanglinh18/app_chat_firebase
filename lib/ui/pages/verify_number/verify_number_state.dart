part of 'verify_number_cubit.dart';

class VerifyNumberState extends Equatable {
  final String? otpValue;

  const VerifyNumberState({this.otpValue = ''});
  VerifyNumberState copyWith({
    String? otpValue,
  }) {
    return VerifyNumberState(
      otpValue: otpValue ?? this.otpValue,
    );
  }

  // TODO: implement props
  @override
  List<Object?> get props => [otpValue];
}

