import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final Color alwaysStoppedAnimation;

  const LoadingIndicatorWidget({
    Key? key,
    this.color = Colors.white,
    this.height = 24,
    this.width = 24,
    this.alwaysStoppedAnimation = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          backgroundColor: color,
          valueColor: AlwaysStoppedAnimation<Color>(alwaysStoppedAnimation),
        ),
      ),
    );
  }
}
