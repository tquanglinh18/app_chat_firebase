import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';

import '../../../common/app_text_styles.dart';
import '../profile_user/profile_user_page.dart';

class VerifyNumberPage extends StatefulWidget {
  String? phoneNumber;

  VerifyNumberPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<VerifyNumberPage> createState() => _VerifyNumberPageState();
}

class _VerifyNumberPageState extends State<VerifyNumberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(onBackPressed: Navigator.of(context).pop),
          const SizedBox(height: 170),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Enter Code\n',
                  style: AppTextStyle.blackS18.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                TextSpan(
                  text: 'We have sent you an SMS with the code to \n ${widget.phoneNumber}',
                  style: AppTextStyle.blackS14.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  //shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(1)],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  //shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).nextFocus();
                    } else {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  //shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length == 1) {
                      FocusScope.of(context).nextFocus();
                    } else {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(1)],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  //shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(1)],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileUserPage()));
              print('On clicked');
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
}
