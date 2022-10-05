import 'package:flutter/material.dart';

import 'item_progress_view.dart';

class ProgressView extends StatefulWidget {
  final int length;
  final VoidCallback onPopScreen;
  final Function(int) nextImage;
  final Function(int) changeIndexPage;

  const ProgressView({
    Key? key,
    this.length = 1,
    required this.onPopScreen,
    required this.nextImage,
    required this.changeIndexPage,
  }) : super(key: key);

  @override
  State<ProgressView> createState() => ProgressViewState();
}

class ProgressViewState extends State<ProgressView> {
  late List<GlobalKey<ItemProgressViewState>> _viewKey;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    _viewKey = List<GlobalKey<ItemProgressViewState>>.generate(
        widget.length, (index) => GlobalKey(debugLabel: 'key_$index'),
        growable: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewKey[0].currentState?.startTimer();
    });
  }

  onPageChanged(int indexChange, indexPageCurrent) {
    if (indexChange == indexPageCurrent - 1) {
      _viewKey[indexPageCurrent].currentState?.cancel();
      _viewKey[indexChange].currentState?.resetTimer();
    } else {
      _viewKey[indexPageCurrent].currentState?.complete();
      _viewKey[indexChange].currentState?.resetTimer();
    }
    widget.changeIndexPage(indexChange);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
          controller: controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ItemProgressView(
              key: _viewKey[index],
              widthItem: (MediaQuery.of(context).size.width - 50) / widget.length,
              indexItem: index,
              onFinishTimer: (indexItem) {
                if (widget.length > 1) {
                  if (indexItem == (widget.length - 1)) {
                    widget.onPopScreen();
                  } else {
                    widget.nextImage(indexItem + 1);
                    _viewKey[indexItem + 1].currentState?.resetTimer();
                  }
                } else {
                  widget.onPopScreen();
                }
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(width: 2);
          },
          itemCount: widget.length),
    );
  }
}
