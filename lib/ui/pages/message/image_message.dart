import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_text_styles.dart';

class ImageMessage extends StatelessWidget {
  String? message;
  String? urlImage;
  bool? isSent = false;
  bool? isSeen = false;

  ImageMessage({
    Key? key,
    this.message,
    this.isSent = false,
    this.isSeen = false,
    this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent != false ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        // width: MediaQuery.of(context).size.width * (2 / 3),
        padding: const EdgeInsets.all(10),
        margin: isSent != false ? const EdgeInsets.fromLTRB(93, 6, 6, 6) : const EdgeInsets.fromLTRB(6, 6, 93, 6),
        decoration: BoxDecoration(
          color: (isSent != true) ? AppColors.backgroundLight : AppColors.btnColor,
          borderRadius: (isSent != true)
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
        ),
        child: Column(
          crossAxisAlignment: (isSent != true) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
           // AspectRatio(
             // aspectRatio: 246 / 150,
             // child:
              Image.network(urlImage!, fit: BoxFit.cover,),
            //),
            const SizedBox(height: 10),
            Text(
              message!,
              style: (isSent != true)
                  ? AppTextStyle.blackS14.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    )
                  : AppTextStyle.whiteS14.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              (isSeen != true) ? "time" : "time • Read",
              style: (isSent != true)
                  ? AppTextStyle.blackS14.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    )
                  : AppTextStyle.whiteS14.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
