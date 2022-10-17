import 'package:flutter/material.dart';
import 'package:flutter_base/ui/commons/img_network.dart';

import '../../../widgets/appbar/app_bar_widget.dart';

class ViewImgArchvies extends StatelessWidget {
  final String urlImg;
  final String nameSent;

  const ViewImgArchvies({
    Key? key,
    required this.urlImg,
    required this.nameSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            title: '$nameSent',
            onBackPressed: Navigator.of(context).pop,
            showBackButton: true,
            colorIcon: Theme.of(context).iconTheme.color!,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ImgNetwork(
              linkUrl: urlImg,
            ),
          ),
        ],
      ),
    );
  }
}
