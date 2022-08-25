import 'package:flutter/material.dart';

import 'custom_progress_hud.dart';

class MyDialog {
  static CustomProgressHUD buildProgressDialog({
    bool loading = false,
    Color? color,
    double? width,
    double? height,
  }) {
    return CustomProgressHUD(
      width: width ?? 50.0,
      height: height ?? 50.0,
      strokeWidth: 5.0,
      backgroundColor: Colors.transparent,
      color: color ?? Colors.red,
      borderRadius: 8.0,
      loading: loading,
    );
  }
}
