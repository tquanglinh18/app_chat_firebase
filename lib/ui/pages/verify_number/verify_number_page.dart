import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/blocs/app_cubit.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/custom_progress_hud.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/my_dialog.dart';
import 'package:flutter_base/ui/pages/profile_user/profile_user_page.dart';
import 'package:flutter_base/ui/pages/verify_number/verify_number_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_text_styles.dart';
import '../../commons/otp/animation_type.dart';
import '../../commons/otp/pin_theme.dart';
import '../../commons/otp/pin_code_text_field.dart';
import '../input_number/input_number_cubit.dart';

class VerifyNumberPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationIDReceived;

  const VerifyNumberPage({Key? key, required this.phoneNumber, required this.verificationIDReceived}) : super(key: key);

  @override
  State<VerifyNumberPage> createState() => _VerifyNumberPageState();
}

class _VerifyNumberPageState extends State<VerifyNumberPage> {
  static final TextEditingController _textOTPController = TextEditingController();
  late VerifyNumberCubit _cubitVerify;
  late InputNumberCubit _cubitInput;
  late AppCubit _cubitApp;
  late final CustomProgressHUD _customProgressHUD;

  @override
  void initState() {
    super.initState();
    _cubitVerify = VerifyNumberCubit(fireBaseAuth: FirebaseAuth.instance);
    _cubitInput = InputNumberCubit(fireBaseAuth: FirebaseAuth.instance);
    _cubitApp = BlocProvider.of<AppCubit>(context);
    _customProgressHUD = MyDialog.buildProgressDialog(
      loading: false,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar,
              const SizedBox(height: 80),
              _guideEnterOtpCode,
              const SizedBox(height: 50),
              buildOtp,
              const SizedBox(height: 50),
              _reSentCode,
            ],
          ),
          _customProgressHUD,
        ],
      ),
    );
  }

  Widget get _buildAppBar {
    return AppBarWidget(
      onBackPressed: Navigator.of(context).pop,
      colorIcon: Theme.of(context).iconTheme.color!,
    );
  }

  Widget get _guideEnterOtpCode {
    return Column(
      children: [
        Text(
          'Enter Code',
          style: AppTextStyle.blackS18.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Theme.of(context).iconTheme.color!,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We have sent you an SMS with the code to \n ${widget.phoneNumber}',
          textAlign: TextAlign.center,
          style: AppTextStyle.blackS14.copyWith(
            fontWeight: FontWeight.w400,
            height: 2,
            color: Theme.of(context).iconTheme.color!,
          ),
        ),
      ],
    );
  }

  Widget get _reSentCode {
    return BlocConsumer<InputNumberCubit, InputNumberState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          _customProgressHUD.progress.show();
        } else {
          _customProgressHUD.progress.dismiss();
          if (state.loadStatus == LoadStatus.success) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.SUCCESS,
              message: "Nhap ma OTP nhan duoc!",
            );
          } else if (state.loadStatus == LoadStatus.failure) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.ERROR,
              message: state.error,
            );
          }
        }
      },
      listenWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      bloc: _cubitInput,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            _cubitInput.verifyNumber(widget.phoneNumber);
          },
          child: Text(
            'Resent code',
            style: AppTextStyle.whiteS16.copyWith(
              color: AppColors.btnColor,
            ),
          ),
        );
      },
    );
  }

  Widget get buildOtp {
    return BlocConsumer<VerifyNumberCubit, VerifyNumberState>(
      bloc: _cubitVerify,
      listenWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          _customProgressHUD.progress.show();
        } else {
          _customProgressHUD.progress.dismiss();
          if (state.loadStatus == LoadStatus.failure) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.ERROR,
              message: state.error,
            );
          } else if (state.loadStatus == LoadStatus.success) {
            _cubitApp.saveIdUser(state.idUser);
            SharedPreferencesHelper.setPhoneUserLoginKey(widget.phoneNumber);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfileUserPage(),
              ),
            );
          }
        }
      },
      buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      builder: (context, state) {
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
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
            onCompleted: (value) {},
            onChanged: (value) {
              if (_textOTPController.text.length == 6) {
                _cubitVerify.verifyCode(
                  verificationIDReceived: widget.verificationIDReceived,
                  verificationIDInput: _textOTPController.text,
                );
              }
            },
          ),
        );
      },
    );
  }
}
