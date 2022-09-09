import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/message/pages/archvies/archives_document.dart';

import '../../type_document.dart';

final List<TypeDocument> listDocument = [
  TypeDocument.IMAGE,
  TypeDocument.FILE,
  TypeDocument.VIDEO,
];

class DialogViewDocument extends StatefulWidget {
  String imgPath;
  String nameUser;
  List<String> listDocument;

  DialogViewDocument({
    Key? key,
    required this.imgPath,
    required this.nameUser,
    this.listDocument = const [],
  }) : super(key: key);

  @override
  State<DialogViewDocument> createState() => _DialogViewDocumentState();
}

class _DialogViewDocumentState extends State<DialogViewDocument> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        decoration: const BoxDecoration(
          color: AppColors.greyBG,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            _appBar(),
            _userChat(
              imgPath: widget.imgPath,
              nameUser: widget.nameUser,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _viewDocument(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Thông tin cuộc hội thoại',
              style: AppTextStyle.blackS18.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.hintTextColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userChat({required String imgPath, required String nameUser}) {
    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ImgFile(
              urlFile: imgPath,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            nameUser,
            style: AppTextStyle.blackS18.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewDocument() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: AppColors.backgroundLight,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Icon(
                  Icons.image,
                  color: AppColors.backgroundLight,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                "Kho lưu trữ",
                style: AppTextStyle.blackS14.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textFieldDisabledBorder,
                ),
              ),
            ],
          ),
          _space,
          _optionDocumentView(),
          _space,
          _previewImageIsEmpty(),
          _space,
          _previewImage(),
        ],
      ),
    );
  }

  Widget get _space {
    return const SizedBox(height: 20);
  }

  Widget _optionDocumentView() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print(index);
            },
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  listDocument[index].toTypeDocument,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        itemCount: 2,
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 60,
            width: 2,
            color: AppColors.hintTextColor,
          );
        },
      ),
    );
  }

  Widget _previewImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 4 - 25,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.width / 4 - 25,
                  width: MediaQuery.of(context).size.width / 4 - 25,
                  decoration: const BoxDecoration(
                    color: AppColors.isOnlineColor,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemCount: 4,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ArchivesDocument(),
                ),
              );
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.hintTextColor),
              child: const Icon(
                Icons.navigate_next_rounded,
                color: AppColors.backgroundLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewImageIsEmpty() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.greyBG,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width - 50,
      child: Row(
        children: [
          const Icon(
            Icons.image_sharp,
            size: 50,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              "Hình ảnh mới nhất của cuộc hội thoại sẽ hiển thị ở đây",
              style: AppTextStyle.blackS14.copyWith(fontSize: 15),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
