import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomProgressHUD extends StatefulWidget {
  final double? width;
  final double? height;
  final double? strokeWidth;

  final Color backgroundColor;
  final Color color;
  final Color containerColor;
  final double borderRadius;
  final String? text;
  final bool loading;
  late CustomProgressHUDState progress;

  CustomProgressHUD(
      {Key? key,
      this.width,
      this.height,
      this.strokeWidth,
      this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text,
      this.loading = true})
      : super(key: key);

  @override
  State<CustomProgressHUD> createState() {
    progress = CustomProgressHUDState();

    return progress;
  }
}

class CustomProgressHUDState extends State<CustomProgressHUD> {
  bool? _visible = true;

  @override
  void initState() {
    super.initState();
    _visible = widget.loading;
  }

  void dismiss() {
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      _visible = false;
    });
  }

  void show() {
    if (!mounted) {
      return; // Just do nothing if the widget is disposed.
    }
    setState(() {
      _visible = true;
    });

    // Future.delayed(Duration(seconds: 10), () {
    //   if (!mounted) {
    //     return; // Just do nothing if the widget is disposed.
    //   }
    //   logger.d("quanth: 091825112020 auto dismiss loading");
    //   setState(() {
    //     this._visible = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (_visible!) {
      return Scaffold(
          backgroundColor: widget.backgroundColor,
          body: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: widget.containerColor,
                      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
                ),
              ),
              Center(
                child: _getCenterContent(),
              )
            ],
          ));
    } else {
      return const SizedBox();
    }
  }

  Widget _getCenterContent() {
    if (widget.text == null || widget.text!.isEmpty) {
      return _getCircularProgress();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getCircularProgress(),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: Text(
              widget.text!,
              style: TextStyle(color: widget.color),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CircularProgressIndicator(
          strokeWidth: widget.strokeWidth!,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
        ),
      ),
    );
  }
}
