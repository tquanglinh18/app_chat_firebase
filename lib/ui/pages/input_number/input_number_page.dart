import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/pages/verify_number/verify_number_page.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../commons/app_buttons.dart';
import '../../widgets/appbar/app_bar_widget.dart';

class InputNumberPage extends StatefulWidget {
  const InputNumberPage({Key? key}) : super(key: key);

  @override
  State<InputNumberPage> createState() => _InputNumberPageState();
}

class _InputNumberPageState extends State<InputNumberPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            onBackPressed: Navigator.of(context).pop,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 170),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Enter Your Phone Number\n',
                          style: AppTextStyle.blackS18.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        TextSpan(
                          text: 'Please confirm your country code and enter your phone number',
                          style: AppTextStyle.blackS14.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  InternationalPhoneNumberInput(
                    autoFocus: true,
                    onInputChanged: (PhoneNumber number) {
                     print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {

                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: PhoneNumber(isoCode: 'VN'),
                    textFieldController: controller,
                    formatInput: false,
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                    inputBorder: const OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {
                     print('On Saved: $number');
                    },
                  ),
                  const SizedBox(height: 81),
                  AppButtons(
                    title: "Continue",
                    onTap: () {
                      print(controller.text);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VerifyNumberPage(
                            phoneNumber: controller.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
