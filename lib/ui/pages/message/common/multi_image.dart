import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';

List<String> urlImage = [];

class MultiImage extends StatefulWidget {
  const MultiImage({Key? key}) : super(key: key);

  @override
  State<MultiImage> createState() => _MultiImageState();
}

class _MultiImageState extends State<MultiImage> {
  @override
  Widget build(BuildContext context) {
    double widthMsg = MediaQuery.of(context).size.width - 100 - 20;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(6, 2, 93, 6),
                decoration: const BoxDecoration(
                  color: AppColors.btnColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: _isTwoImage(),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(6, 2, 93, 6),
                decoration: const BoxDecoration(
                  color: AppColors.btnColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: _isThreeImage(),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(6, 2, 93, 6),
                decoration: const BoxDecoration(
                  color: AppColors.btnColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: _multiImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _isTwoImage() {
    return SizedBox(
      height: 350,
      width: MediaQuery.of(context).size.width - 100 - 20,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 400,
            width: (MediaQuery.of(context).size.width - 100 - 20) / 2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                border: Border.all(
                  width: 3,
                  color: AppColors.textWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _isThreeImage() {
    return SizedBox(
      height: 350,
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
                return SizedBox(
                  height: 350 / 2,
                  width: (MediaQuery.of(context).size.width - 93 - 50) * 1 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      border: Border.all(
                        width: 3,
                        color: AppColors.textWhite,
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
      height: 350,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _firstImage(),
          Expanded(
            child: Column(
              children: [
                _image(),
                _image(),
                _lastImage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _firstImage() {
    return Container(
      height: 350,
      width: (MediaQuery.of(context).size.width - 93 - 50) * 2 / 3,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border.all(
          width: 3,
          color: AppColors.textWhite,
        ),
      ),
    );
  }

  Widget _image() {
    return Container(
      height: 350 / 3,
      width: MediaQuery.of(context).size.width * 1 / 3,
      decoration: BoxDecoration(color: AppColors.primary, border: Border.all(width: 3, color: AppColors.textWhite)),
    );
  }

  Widget _lastImage() {
    return Stack(
      children: [
        Container(
          height: 350 / 3,
          width: MediaQuery.of(context).size.width * 1 / 3,
          decoration: BoxDecoration(color: AppColors.greyBG, border: Border.all(width: 3, color: AppColors.textWhite)),
        ),
        Container(
          alignment: Alignment.center,
          height: 350 / 3,
          width: MediaQuery.of(context).size.width * 1 / 3,
          decoration: BoxDecoration(
              color: AppColors.greyBgr.withOpacity(0.5), border: Border.all(width: 3, color: AppColors.textWhite)),
          child: const Text(
            "+7",
          ),
        ),
      ],
    );
  }
}
