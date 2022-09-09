import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/pages/message/pages/archvies/archives_document_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/app_colors.dart';
import '../../type_document.dart';

final List<TypeDocument> listDocument = [
  TypeDocument.IMAGE,
  TypeDocument.FILE,
  TypeDocument.VIDEO,
];

class ArchivesDocument extends StatefulWidget {
  const ArchivesDocument({Key? key}) : super(key: key);

  @override
  State<ArchivesDocument> createState() => _ArchivesDocumentState();
}

class _ArchivesDocumentState extends State<ArchivesDocument> {
  late ArchivesDocumentCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ArchivesDocumentCubit();
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
                child: state.indexTypeDocument == 0
                    ? _viewImage()
                    : state.indexTypeDocument == 1
                        ? _viewFile()
                        : _viewVideo(),
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
    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      child: ListView.separated(
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
                color: AppColors.btnColor,
              ),
              child: Center(
                child: Text(
                  listDocument[index].name,
                  style: AppTextStyle.whiteS14,
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
  }

  Widget _viewImage() {
    return Container(
      color: Colors.red,
    );
  }

  Widget _viewFile() {
    return Container(
      color: Colors.green,
    );
  }

  Widget _viewVideo() {
    return Container(
      color: Colors.amber,
    );
  }
}
