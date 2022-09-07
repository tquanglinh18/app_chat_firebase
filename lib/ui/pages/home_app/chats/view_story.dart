import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';

class ViewStory extends StatefulWidget {
  final List<String> urlImagePath;
  final String name;
  final String urlAvatar;

  const ViewStory({
    Key? key,
    required this.urlImagePath,
    this.name = '',
    this.urlAvatar = '',
  }) : super(key: key);

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildPageView,
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 3,
                    width: MediaQuery.of(context).size.width - 32,
                    child: _buildProgressView,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.backgroundDark,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildPageView {
    return PageView(
      children: widget.urlImagePath
          .asMap()
          .map((index, value) {
            return MapEntry(
              index,
              _buildItemPageView(widget.urlImagePath[index]),
            );
          })
          .values
          .toList(),
    );
  }

  Widget _buildItemPageView(String path) {
    return Image.file(
      File(path),
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.info_outline,
                color: AppColors.border,
              ),
              SizedBox(height: 15),
              Text("Đã xảy ra lỗi!"),
            ],
          ),
        );
      },
    );
  }

  Widget get _buildProgressView {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildItemProgressView();
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 2);
        },
        itemCount: widget.urlImagePath.length);
  }

  Widget _buildItemProgressView() {
    return Container(
      height: 2,
      width: (MediaQuery.of(context).size.width - 32 - 40) / widget.urlImagePath.length,
      color: Colors.red,
    );
  }
}
