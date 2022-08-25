import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base/models/enums/load_status.dart';

part 'verify_number_state.dart';

class VerifyNumberCubit extends Cubit<VerifyNumberState> {
  final FirebaseAuth fireBaseAuth;
  VerifyNumberCubit({required this.fireBaseAuth}) : super(const VerifyNumberState());

  otpValueChanged(String? otpValue) {
    emit(state.copyWith(otpValue: otpValue));
  }

  void verifyCode({required String verificationIDReceived, required String verificationIDInput}) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: verificationIDInput,
      );
      await fireBaseAuth.signInWithCredential(credential).then((value) {
        emit(state.copyWith(loadStatus: LoadStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure, error: e.toString()));

    }
  }
}
