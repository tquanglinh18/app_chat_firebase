import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'input_number_state.dart';

class InputNumberCubit extends Cubit<InputNumberState> {
  InputNumberCubit() : super(const InputNumberState());

  phoneNumberChanged(String? phoneNumber) {
    print(phoneNumber);
    emit(state.copyWith(phoneNumber: phoneNumber));
  }
}
