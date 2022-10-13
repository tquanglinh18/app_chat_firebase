import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/models/entities/story_entity.dart';
import 'package:flutter_base/ui/commons/img_network.dart';
import 'package:flutter_base/ui/pages/home/chats/view_story/view_story_cubit.dart';

import '../../../../../common/app_colors.dart';
import '../../progress/progress_view.dart';

class ViewStory extends StatefulWidget {
  final List<StoryItemEntity> urlImagePath;
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
                _buildItemPageView(widget.urlImagePath[widget.urlImagePath.length - 1 - index].urlImage ?? ''),
              );
            },
          )
          .values
          .toList(),
    );
  }

  Widget _buildItemPageView(String path) {
    return ImgNetwork(linkUrl: path);
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
        controller.nextPage(duration: const Duration(milliseconds: 50), curve: Curves.ease);
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

  Widget _buildUserUpStory({
    required String name,
    required String urlAvatar,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 48,
              width: 48,
              child: ImgNetwork(
                linkUrl: urlAvatar,
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
