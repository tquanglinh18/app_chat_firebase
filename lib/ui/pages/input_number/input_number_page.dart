import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/pages/verify_number/verify_number_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../commons/app_buttons.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import 'input_number_cubit.dart';

class InputNumberPage extends StatefulWidget {
  const InputNumberPage({Key? key}) : super(key: key);

  @override
  State<InputNumberPage> createState() => _InputNumberPageState();
}

class _InputNumberPageState extends State<InputNumberPage> {
  String heardPhone = '';
  String phoneNumber = '';
  late InputNumberCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = InputNumberCubit(fireBaseAuth: FirebaseAuth.instance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          AppBarWidget(onBackPressed: Navigator.of(context).pop),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Enter Your Phone Number',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.blackS18.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please confirm your country code and enter your phone number',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w400, height: 1.4),
                      ),
                      const SizedBox(height: 48),
                      _inputPhoneNumberField,
                      const SizedBox(height: 81),
                      _continueBtn,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _continueBtn{
    return BlocConsumer<InputNumberCubit, InputNumberState>(
      bloc: _cubit,
      listenWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VerifyNumberPage(
                phoneNumber: "$heardPhone $phoneNumber",
                verificationIDReceived: state.verificationIDReceived,
              ),
            ),
          );
        } else {
          if (state.loadStatus == LoadStatus.failure) {
            DxFlushBar.showFlushBar(
              context,
              type: FlushBarType.ERROR,
              message: state.error,
            );
          }
        }
      },
      buildWhen: (pre, cur) => pre.phoneNumber != cur.phoneNumber || pre.loadStatus != cur.loadStatus,
      builder: (context, state) {
        return AppButtons(
          buttonType: state.phoneNumber != '' ? ButtonType.ACTIVE : ButtonType.IN_ACTIVE,
          title: "Continue",
          isLoading: state.loadStatus == LoadStatus.loading,
          onTap: () {
            _cubit.verifyNumber("$heardPhone $phoneNumber");
          },
        );
      },
    );
  }

  Widget get _inputPhoneNumberField{
    return InternationalPhoneNumberInput(
      autoFocus: true,
      onInputChanged: (PhoneNumber number) {
        heardPhone = number.dialCode ?? "";
        phoneNumber = (number.phoneNumber ?? "").split(heardPhone)[1];
        _cubit.phoneNumberChanged(phoneNumber);
      },
      onInputValidated: (bool value) {},
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.black),
      initialValue: PhoneNumber(isoCode: 'VN'),
      formatInput: false,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const OutlineInputBorder(),
      onSaved: (PhoneNumber number) {},
    );
  }
}
