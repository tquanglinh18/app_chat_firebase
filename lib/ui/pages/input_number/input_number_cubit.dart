import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:meta/meta.dart';

part 'input_number_state.dart';

class InputNumberCubit extends Cubit<InputNumberState> {
  final FirebaseAuth fireBaseAuth;
  InputNumberCubit({required this.fireBaseAuth,}) : super(const InputNumberState());

  phoneNumberChanged(String? phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void verifyNumber(String phoneNumber) {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    fireBaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await fireBaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          emit(state.copyWith(loadStatus: LoadStatus.failure,error: exception.message, ));
        },
        codeSent: (String verificationID, int? resentToken) {
          emit(state.copyWith(loadStatus: LoadStatus.success, verificationIDReceived: verificationID));
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
        timeout: const Duration(seconds: 60));
  }
}
