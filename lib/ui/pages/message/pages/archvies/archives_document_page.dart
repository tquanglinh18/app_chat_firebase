import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/message/pages/archvies/archives_document_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';

import '../../../../../common/app_colors.dart';
import '../../../../../models/entities/message_entity.dart';
import '../../type_document.dart';
import '../play_video.dart';

final List<TypeDocument> listDocument = [
  TypeDocument.IMAGE,
  TypeDocument.FILE,
  TypeDocument.VIDEO,
];

class ArchivesDocumentPage extends StatefulWidget {
  String uid;
  List<MessageEntity> listImg;
  List<MessageEntity> listVideo;
  List<MessageEntity> listFile;
  int? indexDocument;

  ArchivesDocumentPage({
    Key? key,
    required this.uid,
    required this.listImg,
    required this.listVideo,
    required this.listFile,
    required this.indexDocument,
  }) : super(key: key);

  @override
  State<ArchivesDocumentPage> createState() => _ArchivesDocumentPageState();
}

class _ArchivesDocumentPageState extends State<ArchivesDocumentPage> {
  late ArchivesDocumentCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ArchivesDocumentCubit();
    _cubit.getListDocument(widget.uid);
    _cubit.isSelectedType(widget.indexDocument ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ArchivesDocumentCubit, ArchivesDocumentState>(
        bloc: _cubit,
        buildWhen: (pre, cur) => pre.indexTypeDocument != cur.indexTypeDocument,
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar,
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.hintTextColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: _listDocument(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: state.indexTypeDocument == 0
                      ? _viewImage()
                      : state.indexTypeDocument == 1
                          ? _viewFile()
                          : _viewVideo(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get _buildAppBar {
    return AppBarWidget(
      title: "Kho lưu trữ",
      onBackPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _listDocument() {
    return BlocBuilder<ArchivesDocumentCubit, ArchivesDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.indexTypeDocument != cur.indexTypeDocument,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(5),
          height: 50,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _cubit.isSelectedType(index);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: state.indexTypeDocument == index ? AppColors.btnColor : AppColors.backgroundLight,
                    border: Border.all(
                      color: state.indexTypeDocument == index ? Colors.transparent : AppColors.btnColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      listDocument[index].name,
                      style: state.indexTypeDocument == index
                          ? AppTextStyle.whiteS14
                          : AppTextStyle.blackS14.copyWith(
                              color: AppColors.btnColor,
                            ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 15);
            },
            itemCount: listDocument.length,
          ),
        );
      },
    );
  }

  Widget _viewImage() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.listImg.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ImgFile(
            urlFile: (widget.listImg[index].document ?? []).first.path ?? "",
          ),
        );
      },
    );
  }

  Widget _viewFile() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: widget.listFile.length,
      itemBuilder: (context, index) {
        return _itemFilePreview(
          name: (widget.listFile[index].document ?? []).first.name ?? "",
          onTap: () {
            OpenFile.open(
              (widget.listFile[index].document ?? []).first.path,
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(height: 5);
      },
    );
  }

  Widget _viewVideo() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: widget.listVideo.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlayVideo(
                  nameConversion: 'Video',
                  path: (widget.listVideo[index].document ?? []).first.path ?? "",
                ),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ImgFile(urlFile: (widget.listVideo[index].document ?? []).first.pathThumbnail ?? ""),
              const Icon(Icons.play_circle),
            ],
          ),
        );
      },
    );
  }

  Widget _itemFilePreview({
    required String name,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 63,
            height: 63,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: AppColors.hintTextColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Center(
              child: Icon(
                Icons.file_copy,
                color: AppColors.hintTextColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(name),
        ],
      ),
    );
  }
}
