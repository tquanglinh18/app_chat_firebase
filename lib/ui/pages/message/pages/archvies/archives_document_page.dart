import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/datetime_formatter.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/commons/img_network.dart';
import 'package:flutter_base/ui/pages/message/pages/archvies/archives_document_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import '../../../../../common/app_colors.dart';
import '../../../../../models/entities/message_entity.dart';
import '../../../../commons/data_empty.dart';
import '../../type_document.dart';

final List<TypeDocument> listDocument = [
  TypeDocument.IMAGE,
  TypeDocument.FILE,
  TypeDocument.VIDEO,
];

class ArchivesDocumentPage extends StatefulWidget {
  final String uid;
  final List<DocumentEntity> listImg;
  final List<DocumentEntity> listVideo;
  final List<DocumentEntity> listFile;
  final int? indexDocument;

  const ArchivesDocumentPage({
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
    super.initState();
    _cubit = ArchivesDocumentCubit();
    _cubit.isSelectedType(
      widget.indexDocument ?? 0,
      widget.listFile,
      widget.listVideo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).focusColor,
      body: BlocBuilder<ArchivesDocumentCubit, ArchivesDocumentState>(
        bloc: _cubit,
        buildWhen: (pre, cur) => pre.indexTypeDocument != cur.indexTypeDocument,
        builder: (context, state) {
          return Column(
            children: [
              _buildAppBar,
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).focusColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: _listDocument(),
                ),
              ),
              Expanded(
                child: state.indexTypeDocument == 0
                    ? _viewImage
                    : state.indexTypeDocument == 1
                        ? _viewFile
                        : _viewVideo,
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
      colorIcon: Theme.of(context).iconTheme.color!,
    );
  }

  Widget _listDocument() {
    return BlocBuilder<ArchivesDocumentCubit, ArchivesDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.indexTypeDocument != cur.indexTypeDocument,
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _cubit.isSelectedType(index, widget.listFile, widget.listVideo);
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

  Widget get _viewImage {
    return Container(
      child: widget.listImg.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: widget.listImg.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      _checkExists(widget.listImg[index].path!);
                    },
                    child: ImgNetwork(
                      urlFile: (widget.listImg[index].path ?? ""),
                    ),
                  ),
                );
              },
            )
          : DataEmpty(color: Theme.of(context).iconTheme.color!),
    );
  }

  Widget get _viewFile {
    return BlocBuilder<ArchivesDocumentCubit, ArchivesDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      builder: (context, state) {
        return state.listDocumentFile.isNotEmpty
            ? ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.listDocumentFile.length,
                itemBuilder: (context, index) {
                  return _itemFilePreview(
                    name: state.listDocumentFile[index].name ?? "",
                    onTap: () {
                      _checkExists(state.listDocumentFile[index].path ?? "");
                    },
                    type: (state.listDocumentFile[index].name ?? "").split('.').last,
                    nameSend: state.listDocumentFile[index].nameSend ?? "",
                    timeSend: (state.listDocumentFile[index].createAt ?? "").split(' ').first,
                    isHeader: state.listDocumentFile[index].isHeader,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 3,
                    color: AppColors.greyBgr,
                  );
                },
              )
            : DataEmpty(color: Theme.of(context).iconTheme.color!);
      },
    );
  }

  Widget get _viewVideo {
    return BlocBuilder<ArchivesDocumentCubit, ArchivesDocumentState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      builder: (context, state) {
        return state.listDocumentVideo.isNotEmpty
            ? ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.listDocumentVideo.length,
                itemBuilder: (context, index) {
                  return _itemFilePreview(
                    name: (state.listDocumentVideo[index].name ?? ""),
                    onTap: () {
                      _checkExists(
                        (state.listDocumentVideo[index].path!),
                      );
                    },
                    type: (state.listDocumentVideo[index].name ?? "").split(".").last,
                    nameSend: state.listDocumentVideo[index].nameSend ?? "",
                    timeSend: (state.listDocumentVideo[index].createAt ?? "").split(' ').first,
                    isHeader: state.listDocumentVideo[index].isHeader,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 3,
                    color: AppColors.greyBgr,
                  );
                },
              )
            : DataEmpty(color: Theme.of(context).iconTheme.color!);
      },
    );
  }

  Widget _itemFilePreview({
    required String name,
    required Function() onTap,
    required String type,
    required String nameSend,
    required bool isHeader,
    required String timeSend,
  }) {
    return isHeader
        ? Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            child: Text(
              "Ngày ${DateFormat('dd-MM-yyyy').format(timeSend.toDateLocal() ?? DateTime.now())}",
              style: AppTextStyle.greyS14.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          )
        : Container(
            color: AppColors.backgroundLight,
            padding: const EdgeInsets.all(15),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.btnColor,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: type == "pdf"
                          ? Image.asset(AppImages.icFilePdf)
                          : type == "docx" || type == "doc"
                              ? Image.asset(
                                  AppImages.icFileDocx,
                                  height: 25,
                                )
                              : type == "xlxs"
                                  ? Image.asset(
                                      AppImages.icFileXlxs,
                                      height: 25,
                                    )
                                  : Image.asset(
                                      AppImages.icFileVideo,
                                      height: 25,
                                    ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          nameSend,
                          style: AppTextStyle.greyS14.copyWith(fontWeight: FontWeight.w300),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _checkExists(String fileName) async {
    if (await File(fileName).exists()) {
      OpenFile.open(fileName);
    } else {
      if (!mounted) return;
      DxFlushBar.showFlushBar(
        context,
        title: "Tệp tin không tồn tại!",
        type: FlushBarType.ERROR,
      );
    }
  }
}
