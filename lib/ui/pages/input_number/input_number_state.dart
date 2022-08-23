part of 'input_number_cubit.dart';

@immutable
class InputNumberState extends Equatable {
  final String? phoneNumber;

  const InputNumberState({this.phoneNumber = ''});
  InputNumberState copyWith({
    String? phoneNumber,
  }) {
    return InputNumberState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber];
}
