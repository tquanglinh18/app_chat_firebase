import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verify_number_state.dart';

class VerifyNumberCubit extends Cubit<VerifyNumberState> {
  VerifyNumberCubit() : super(const VerifyNumberState());

  otpValueChanged(String? otpValue) {
    emit(state.copyWith(otpValue: otpValue));
  }
}
