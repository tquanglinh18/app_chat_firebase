import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/pages/home_app/chats/view_story/view_story_cubit.dart';
import 'package:flutter_base/ui/pages/home_app/progress/progress_view.dart';

import '../../../../../common/app_colors.dart';

class ViewStory extends StatefulWidget {
  final List<String> urlImagePath;
  final String name;
  final String urlAvatar;

  const ViewStory({
    Key? key,
    required this.urlImagePath,
    required this.name,
    required this.urlAvatar,
  }) : super(key: key);

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  late ViewStoryCubit _cubit;
  PageController controller = PageController();
  final GlobalKey<ProgressViewState> _progressViewKey = GlobalKey<ProgressViewState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ViewStoryCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textWhite,
      body: SafeArea(
        top: true,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _buildPageView,
            _buildAppBar,
          ],
        ),
      ),
    );
  }

  Widget get _buildPageView {
    return PageView(
      controller: controller,
      onPageChanged: (index) {
        _progressViewKey.currentState?.onPageChanged(
          index,
          _cubit.state.indexPageView,
        );
      },
      children: widget.urlImagePath
          .asMap()
          .map(
            (index, value) {
              return MapEntry(
                index,
                _buildItemPageView(widget.urlImagePath[index]),
              );
            },
          )
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
    return ProgressView(
      key: _progressViewKey,
      length: widget.urlImagePath.length,
      onPopScreen: () {
        Navigator.of(context).pop();
      },
      nextImage: (indexPage) {
        _cubit.changeIndexPage(indexPage);
        controller.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.ease);
      },
      changeIndexPage: (indexChange) {
        _cubit.changeIndexPage(indexChange);
      },
    );
  }

  Widget get _buildAppBar {
    return Column(
      children: [
        _buildProgressView,
        _buildUserUpStory(
          name: widget.name,
          urlAvatar: widget.urlAvatar,
        ),
      ],
    );
  }

  Widget _buildUserUpStory({required String name, required String urlAvatar}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 48,
              width: 48,
              child: Image.file(
                File(urlAvatar),
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1,
                        color: AppColors.greyBG,
                      ),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppColors.border,
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: AppTextStyle.blackS14,
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
          ),
        ],
      ),
    );
  }
}
