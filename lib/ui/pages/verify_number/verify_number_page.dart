import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/ui/pages/contact/contact_page.dart';
import 'package:flutter_base/ui/pages/verify_number/verify_number_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_text_styles.dart';
import '../../commons/otp/animation_type.dart';
import '../../commons/otp/pin_theme.dart';
import '../../commons/otp/pin_code_text_field.dart';
import '../profile_user/profile_user_page.dart';

class VerifyNumberPage extends StatefulWidget {
  String? phoneNumber;

  VerifyNumberPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<VerifyNumberPage> createState() => _VerifyNumberPageState();
}

class _VerifyNumberPageState extends State<VerifyNumberPage> {
  final _textOTPController = TextEditingController();

  FirebaseAuth fireBaseAuth = FirebaseAuth.instance;
  String verificationIDReceived = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          AppBarWidget(onBackPressed: Navigator.of(context).pop),
          const SizedBox(height: 80),
          Text(
            'Enter Code',
            style: AppTextStyle.blackS18.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We have sent you an SMS with the code to \n ${widget.phoneNumber}',
            textAlign: TextAlign.center,
            style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w400, height: 2),
          ),
          const SizedBox(height: 50),
          buildOtp(),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileUserPage()));
              // print('On clicked');
            },
            child: Text(
              'Resent code',
              style: AppTextStyle.whiteS16.copyWith(color: AppColors.btnColor),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOtp() {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 52),
          child: PinCodeTextField(
            appContext: context,
            controller: _textOTPController,
            length: 6,
            obscureText: false,
            autoFocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            animationType: AnimationType.fade,
            animationDuration: const Duration(milliseconds: 300),
            pinTheme: const PinTheme.defaults(
              activeColor: Colors.grey,
              inactiveColor: Colors.grey,
              selectedColor: Colors.grey,
            ),
            cursorColor: Colors.grey,
            backgroundColor: Colors.white,
            onCompleted: (value) {
              // _cubit.otpValueChanged(value);
              //verificationIDInput = value;
              print("onCompleted -- $value");
            },
            onChanged: (value) {
              if (_textOTPController.text.length == 6) {
                // _cubit.otpValueChanged(value);
                verifyCode();
              }
            },
          ),
        );
  }

  void verifyNumber() {
    fireBaseAuth.verifyPhoneNumber(
        phoneNumber: '${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await fireBaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resentToken) {
          setState(() {
            verificationIDReceived = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {

        },
        timeout: const Duration(seconds: 60));
  }

  void verifyCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: _textOTPController.text,
      );
      await fireBaseAuth.signInWithCredential(credential).then((value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ContactPage(),
          ),
        );
      });
    } catch (e) {
      print(e.toString());
      var snackBar = const SnackBar(
        content: Text('Invalid OTP'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
