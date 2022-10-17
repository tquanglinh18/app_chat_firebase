import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../generated/l10n.dart';
import '../../commons/app_buttons.dart';
import '../../widgets/appbar/app_bar_widget.dart';
import '../verification/verify_number_page.dart';
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
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildAppBar,
                      const SizedBox(height: 80),
                      _guideInputPhoneNumber,
                      const SizedBox(height: 48),
                      _inputPhoneNumberField,
                      const SizedBox(height: 81),
                      _btnContinue,
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

  Widget get _buildAppBar {
    return AppBarWidget(
      onBackPressed: Navigator.of(context).pop,
      colorIcon: Theme.of(context).iconTheme.color!,
    );
  }

  Widget get _guideInputPhoneNumber {
    return Column(
      children: [
        Text(
          S.of(context).phone_input,
          textAlign: TextAlign.center,
          style: AppTextStyle.blackS18.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Theme.of(context).iconTheme.color!,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).phone_input_guide,
          textAlign: TextAlign.center,
          style: AppTextStyle.blackS14.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: Theme.of(context).iconTheme.color!,
          ),
        ),
      ],
    );
  }

  Widget get _btnContinue {
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
          title: S.of(context).continue_,
          isLoading: state.loadStatus == LoadStatus.loading,
          onTap: () {
            _cubit.verifyNumber("$heardPhone $phoneNumber");
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget get _inputPhoneNumberField {
    return InternationalPhoneNumberInput(
      autoFocus: true,
      textStyle: AppTextStyle.blackS18.copyWith(
        fontWeight: FontWeight.w400,
        color: Theme.of(context).iconTheme.color!,
      ),
      onInputChanged: (PhoneNumber number) {
        heardPhone = number.dialCode ?? "";
        phoneNumber = (number.phoneNumber ?? "").split(heardPhone)[1];
        _cubit.phoneNumberChanged(phoneNumber);
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DIALOG,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: TextStyle(
        color: Theme.of(context).iconTheme.color!,
      ),
      initialValue: PhoneNumber(isoCode: 'VN'),
      formatInput: false,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputDecoration: InputDecoration(
        hintText: S.of(context).phone_number,
        hintStyle: AppTextStyle.blackS18.copyWith(
          fontWeight: FontWeight.w400,
          color: Theme.of(context).iconTheme.color!,
        ),
        border: const OutlineInputBorder(),
      ),
      onSaved: (PhoneNumber number) {},
    );
  }
}
