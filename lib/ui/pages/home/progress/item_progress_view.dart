import 'dart:async';
import 'package:flutter/material.dart';

class ItemProgressView extends StatefulWidget {
  final double widthItem;
  final int indexItem;
  final Function(int) onFinishTimer;

  const ItemProgressView({
    Key? key,
    this.widthItem = 0,
    required this.onFinishTimer,
    required this.indexItem,
  }) : super(key: key);

  @override
  State<ItemProgressView> createState() => ItemProgressViewState();
}

class ItemProgressViewState extends State<ItemProgressView> {
  Timer? _timer;
  int _start = 0;
  int totalTimer = 10;
  int _milliseconds = 800;

  @override
  void initState() {
    super.initState();
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == totalTimer) {
          setState(() {
            timer.cancel();
          });
          widget.onFinishTimer(widget.indexItem);
        } else {
          setState(() {
            _start++;
          });
        }
      },
    );
  }

  resetTimer() {
    _timer?.cancel();
    setState(() {
      _start = 0;
      _milliseconds = 800;
    });

    startTimer();
  }

  cancel() {
    setState(() {
      _start = 0;
      _milliseconds = 0;
    });
    _timer?.cancel();
  }

  complete() {
    setState(() {
      _start = totalTimer;
      _milliseconds = 0;
    });
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      width: widget.widthItem,
      child: Stack(
        children: [
          Container(
            width: widget.widthItem,
            color: Colors.grey,
          ),
          AnimatedContainer(
            width: (widget.widthItem * _start) / totalTimer,
            color: Colors.red,
            duration: Duration(milliseconds: _milliseconds),
          )
        ],
      ),
    );
  }
}
