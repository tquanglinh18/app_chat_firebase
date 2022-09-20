import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'flus_bar.dart';

class CheckExists extends StatefulWidget {
  const CheckExists({Key? key}) : super(key: key);

  @override
  State<CheckExists> createState() => _CheckExistsState();
}

class _CheckExistsState extends State<CheckExists> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _checkExists(String fieName) async {
    String fileName = fieName;
    String dir = (await getApplicationDocumentsDirectory()).path;
    String savePath = '$dir/$fileName';
    if (await File(savePath).exists()) {
      OpenFile.open(savePath);
    } else {
      if (!mounted) return;
      DxFlushBar.showFlushBar(
        context,
        title: "Tệp tin không tồn tại!",
        type: FlushBarType.ERROR,
      );
    }
  }
}
