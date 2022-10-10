import 'package:flutter/material.dart';
import 'package:flutter_base/ui/commons/img_network.dart';

import '../../../widgets/appbar/app_bar_widget.dart';

class ViewImgArchvies extends StatelessWidget {
  final String urlImg;

  const ViewImgArchvies({
    Key? key,
    required this.urlImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            title: "Xem ảnh",
            onBackPressed: Navigator.of(context).pop,
            showBackButton: true,
          ),
          AspectRatio(
            aspectRatio: 9/16,
            child: ImgNetwork(
              urlFile: urlImg,
            ),
          ),
        ],
      ),
    );
  }
}
