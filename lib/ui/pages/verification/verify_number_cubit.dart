import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/enums/load_status.dart';

part 'verify_number_state.dart';

class VerifyNumberCubit extends Cubit<VerifyNumberState> {
  final FirebaseAuth fireBaseAuth;

  VerifyNumberCubit({required this.fireBaseAuth}) : super(const VerifyNumberState());

  void verifyCode({required String verificationIDReceived, required String verificationIDInput}) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: verificationIDInput,
      );
      await fireBaseAuth.signInWithCredential(credential).then(
        (value) {
          emit(state.copyWith(loadStatus: LoadStatus.success, idUser: value.user!.uid));
          SharedPreferencesHelper.setUidFireBaseKey(value.user!.uid);
        },
      );
    } catch (e) {
      emit(state.copyWith(loadStatus: LoadStatus.failure, error: e.toString()));
    }
  }
}
