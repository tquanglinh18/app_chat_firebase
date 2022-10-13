import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/ui/pages/message/pages/archvies/archives_document_page.dart';
import 'package:flutter_base/ui/pages/message/pages/view_img_archvies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/app_text_styles.dart';
import '../../../../models/entities/message_entity.dart';
import '../../../commons/img_network.dart';
import 'dialog/dialog_view_document_cubit.dart';

class MultiImage extends StatefulWidget {
  final List<DocumentEntity> listDocumnet;
  final bool isSent;
  final String uid;

  const MultiImage({
    Key? key,
    required this.listDocumnet,
    required this.isSent,
    required this.uid,
  }) : super(key: key);

  @override
  State<MultiImage> createState() => _MultiImageState();
}

class _MultiImageState extends State<MultiImage> {
  late DialogViewDocumentCubit _cubit;

  @override
  void initState() {
    _cubit = DialogViewDocumentCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: widget.listDocumnet.length == 1
          ? InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewImgArchvies(urlImg: widget.listDocumnet.first.path ?? ""),
            ),
          );
        },
            child: ImgNetwork(
                linkUrl: widget.listDocumnet.first.path!,
                textMsgError: 'Đã xảy ra lỗi \nVui lòng thử lại',
                isSent: widget.isSent,
                isBorderSide: true,
                darkModeIconColor: Theme.of(context).iconTheme.color!,
              ),
          )
          : widget.listDocumnet.length == 2
              ? _isTwoImage()
              : widget.listDocumnet.length == 3
                  ? _isThreeImage()
                  : widget.listDocumnet.length >= 4
                      ? _multiImage()
                      : const SizedBox(),
    );
  }

  Widget _isTwoImage() {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width - 120,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewImgArchvies(urlImg: widget.listDocumnet[index].path ?? ""),
                ),
              );
            },
            child: Container(
              height: 250,
              width: (MediaQuery.of(context).size.width - 150) / 2,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: AppColors.textWhite,
                ),
              ),
              child: ImgNetwork(
                linkUrl: widget.listDocumnet[index].path ?? "",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _isThreeImage() {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _firstImage(),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 2,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewImgArchvies(urlImg: widget.listDocumnet[index + 1].path ?? ""),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 300 / 2,
                    width: (MediaQuery.of(context).size.width - 100 - 50) * 1 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: AppColors.textWhite,
                        ),
                      ),
                      child: ImgNetwork(
                        linkUrl: widget.listDocumnet[index + 1].path ?? "",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _multiImage() {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _firstImage(),
          Expanded(
            child: Column(
              children: [
                _image(widget.listDocumnet[1].path ?? ""),
                _image(widget.listDocumnet[2].path ?? ""),
                _lastImage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _firstImage() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewImgArchvies(urlImg: widget.listDocumnet.first.path ?? ""),
          ),
        );
      },
      child: Container(
        height: 300,
        width: (MediaQuery.of(context).size.width - 100 - 50) * 2 / 3,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: AppColors.textWhite,
          ),
        ),
        child: ImgNetwork(
          linkUrl: widget.listDocumnet.first.path ?? "",
        ),
      ),
    );
  }

  Widget _image(String linkUrl) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewImgArchvies(urlImg: linkUrl),
          ),
        );
      },
      child: Container(
        height: 300 / 3,
        width: MediaQuery.of(context).size.width * 1 / 3,
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: AppColors.textWhite,
          ),
        ),
        child: ImgNetwork(linkUrl: linkUrl),
      ),
    );
  }

  Widget _lastImage() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewImgArchvies(urlImg: widget.listDocumnet[3].path ?? ""),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 300 / 3,
            width: MediaQuery.of(context).size.width * 1 / 3,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: AppColors.textWhite,
              ),
            ),
            child: ImgNetwork(
              linkUrl: widget.listDocumnet[3].path ?? "",
            ),
          ),
          BlocBuilder<DialogViewDocumentCubit, DialogViewDocumentState>(
            bloc: _cubit,
            builder: (context, state) {
              return InkWell(
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
                child: Visibility(
                  visible: widget.listDocumnet.length > 4,
                  child: Container(
                    alignment: Alignment.center,
                    height: 300 / 3,
                    width: MediaQuery.of(context).size.width * 1 / 3,
                    decoration: BoxDecoration(
                      color: AppColors.greyBgr.withOpacity(0.7),
                      border: Border.all(
                        width: 3,
                        color: AppColors.textWhite,
                      ),
                    ),
                    child: Text(
                      "+${widget.listDocumnet.length - 4}",
                      style: AppTextStyle.moreImg,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
