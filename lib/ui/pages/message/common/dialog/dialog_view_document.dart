import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/commons/img_network.dart';
import 'package:flutter_base/ui/pages/message/common/dialog/dialog_view_document_cubit.dart';
import 'package:flutter_base/ui/pages/message/pages/archvies/archives_document_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../type_document.dart';

final List<TypeDocument> listDocument = [
  TypeDocument.IMAGE,
  TypeDocument.FILE,
  TypeDocument.VIDEO,
];

class DialogViewDocument extends StatefulWidget {
  final String imgPath;
  final String nameUser;
  final String uid;

  const DialogViewDocument({
    Key? key,
    required this.imgPath,
    required this.nameUser,
    required this.uid,
  }) : super(key: key);

  @override
  State<DialogViewDocument> createState() => _DialogViewDocumentState();
}

class _DialogViewDocumentState extends State<DialogViewDocument> {
  late DialogViewDocumentCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = DialogViewDocumentCubit();
    _cubit.getListDocument(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(top: 100),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            _buildappBar,
            _userChat(
              imgPath: widget.imgPath,
              nameUser: widget.nameUser,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _viewDocument,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildappBar {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Thông tin cuộc hội thoại',
              style: Theme.of(context).textTheme.bodyText1,
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

  Widget _userChat({
    required String imgPath,
    required String nameUser,
  }) {
    return Container(
      color: Theme.of(context).focusColor,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: ImgNetwork(
              urlFile: imgPath,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            nameUser,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget get _viewDocument {
    return BlocBuilder<DialogViewDocumentCubit, DialogViewDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.listImg != cur.listImg,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(15),
          color: Theme.of(context).focusColor,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.btnColor,
                    ),
                    child: const Icon(
                      Icons.image,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Kho lưu trữ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              _space,
              _optionDocumentView,
              _space,
              state.listImg.isEmpty ? _previewImageIsEmpty : _previewImage,
            ],
          ),
        );
      },
    );
  }

  Widget get _space {
    return const SizedBox(height: 20);
  }

  Widget get _optionDocumentView {
    return BlocBuilder<DialogViewDocumentCubit, DialogViewDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) =>
          pre.listFile != cur.listFile || pre.listVideo != cur.listVideo || pre.listImg != cur.listImg,
      builder: (context, state) {
        return SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArchivesDocumentPage(
                        uid: widget.uid,
                        listImg: state.listImg,
                        listVideo: state.listVideo,
                        listFile: state.listFile,
                        indexDocument: index,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    child: Text(
                      listDocument[index].toTypeDocument,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!,
                    ),
                  ),
                ),
              );
            },
            itemCount: 2,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                width: 2,
                color: AppColors.hintTextColor,
              );
            },
          ),
        );
      },
    );
  }

  Widget get _previewImage {
    return BlocBuilder<DialogViewDocumentCubit, DialogViewDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.listImg != cur.listImg,
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.width / 4 - 25,
          child: Row(
            children: [
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.width / 4 - 25,
                      width: MediaQuery.of(context).size.width / 4 - 25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ImgNetwork(
                          urlFile: state.listImg[index].path ?? "",
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                  itemCount: state.listImg.length > 4 ? 4 : state.listImg.length,
                ),
              ),
              state.listImg.length > 4
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ArchivesDocumentPage(
                              uid: widget.uid,
                              listImg: state.listImg,
                              listVideo: state.listVideo,
                              listFile: state.listFile,
                              indexDocument: 0,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.hintTextColor,
                        ),
                        child: const Icon(
                          Icons.navigate_next_rounded,
                          color: AppColors.backgroundLight,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  Widget get _previewImageIsEmpty {
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
            color: AppColors.backgroundDark,
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
