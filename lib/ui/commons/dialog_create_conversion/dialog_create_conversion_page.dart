import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/app_buttons.dart';
import 'package:flutter_base/ui/commons/dialog_create_conversion/dialog_create_conversion_cubit.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/app_colors.dart';
import '../../../generated/l10n.dart';

class DialogCreateCobersion extends StatefulWidget {
  const DialogCreateCobersion({Key? key}) : super(key: key);

  @override
  State<DialogCreateCobersion> createState() => _DialogCreateCobersionState();
}

class _DialogCreateCobersionState extends State<DialogCreateCobersion> {
  final TextEditingController _controller = TextEditingController();
  late DialogCreateConversionCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = DialogCreateConversionCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: MediaQuery.of(context).viewInsets.bottom > 0 ? Alignment.topCenter : Alignment.center,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Material(
          color: Colors.transparent,
          child: BlocBuilder<DialogCreateConversionCubit, DialogCreateConversionState>(
            bloc: _cubit,
            buildWhen: (pre, cur) =>
                pre.nameRoomConversion != cur.nameRoomConversion ||
                pre.imgRoomConversdionPath != cur.imgRoomConversdionPath,
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: MediaQuery.of(context).viewInsets.bottom > 0 ? 150 + MediaQuery.of(context).viewInsets.top : 0,
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? MediaQuery.of(context).viewInsets.bottom / 2
                        : 0),
                padding: const EdgeInsets.only(top: 40, bottom: 30, left: 20, right: 20),
                decoration:
                    const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _createName,
                    const SizedBox(height: 10),
                    _inputNameConversionField,
                    const SizedBox(height: 10),
                    state.imgRoomConversdionPath.isEmpty
                        ? InkWell(
                            onTap: () {
                              _getFromGallery();
                              FocusScope.of(context).unfocus();
                            },
                            child: const Icon(
                              Icons.image,
                              size: 60,
                              color: AppColors.btnColor,
                            ),
                          )
                        : _imgRoomConversion(
                            imgRoomConversdionPath: state.imgRoomConversdionPath,
                          ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _btnCancel,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _btnCreate(
                            nameRoomConversion: state.nameRoomConversion,
                            imgRoomConversdionPath: state.imgRoomConversdionPath,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget get _createName {
    return Text(
      S.of(context).create_conversation,
      style: AppTextStyle.greyS14.copyWith(
        fontSize: 18,
        color: AppColors.btnColor,
      ),
    );
  }

  Widget get _inputNameConversionField {
    return TextFormField(
      onChanged: (value) {
        _cubit.setNameConversionChanged(value);
      },
      controller: _controller,
      cursorColor: AppColors.btnColor,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      autofocus: true,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        isDense: true,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
        hintText: S.of(context).name_conversation,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: AppColors.whiteFAFAFA,
      ),
      keyboardType: TextInputType.text,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Widget _imgRoomConversion({required String imgRoomConversdionPath}) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 60,
              width: 60,
              child: ImgFile(urlFile: imgRoomConversdionPath),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                _cubit.removeImg();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textWhite,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget get _btnCancel {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: AppButtons(
        buttonType: ButtonType.IN_ACTIVE,
        title: S.of(context).cancel,
        heightButton: 42,
        circularButton: 10,
      ),
    );
  }

  Widget _btnCreate({
    required String nameRoomConversion,
    required String imgRoomConversdionPath,
  }) {
    return AppButtons(
      buttonType: ButtonType.ACTIVE,
      title: S.of(context).create,
      heightButton: 42,
      circularButton: 10,
      onTap: () {
        if (imgRoomConversdionPath.isNotEmpty && nameRoomConversion.isNotEmpty) {
          Navigator.of(context).pop({
            "nameConversion": nameRoomConversion,
            "avatarConversion": imgRoomConversdionPath,
            "createAt": DateTime.now().toUtc().toString(),
          });
        } else {
          DxFlushBar.showFlushBar(
            context,
            title: 'Điền đầy đủ thông tin',
            type: FlushBarType.ERROR,
          );
        }
      },
    );
  }

  _getFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    _cubit.setImgRoomConversionPathChanged(image.path);
  }
}
